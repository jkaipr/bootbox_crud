var BBCrud = BBCrud || {};

BBCrud.Modals = (function () {

    var modals = {
      /**
       * Displays a bootbox modal dialog form.
       * @param {Number} id related model id
       * @param {String} title modal dialog title
       * @param {String} btnLabel submit button label
       * @param {String} url URL address pointing to rails route with form partial
       * @param {Function} [onLoad] function to be executed after successfully loading the form partial into the modal dialog
       * @param {Number} [onSubmitTimeout] timeout to use with onSubmit function, if it is defined
       * @param {Function} [onSubmit] function to be executed after the form was submitted
       * @param {Object} options
       * @param {String} options.baseUrl related model base URL, used for delete button
       * @param {Object} options.data
       * @param {Boolean} [options.data.bbDontSubmit] prohibits form submission if set to true, submit just hides the dialog
       * @param {Boolean} [options.data.bbShowDelete] set to true if you don't want to show a delete button on the dialog
       */
        form: function(id, title, btnLabel, url, onLoad, onSubmitTimeout, onSubmit, options) {
            options = $.extend({ data: {} }, options);
            var buttons = {
                close: {
                    "label" : "Close"
                },
                submit: {
                    "label" : btnLabel,
                    "className" : "btn-success",
                    "callback": function() {
                        if (options.data.bbDontSubmit !== true) {
                            $('.bootbox.modal').find('input[type="submit"]').closest('form').submit();
                        }
                        if (onSubmit !== null && typeof onSubmit !== 'undefined') { setTimeout(onSubmit, onSubmitTimeout); }
                        return false;
                    }
                }
            };
            if (id !== -1 && options.data.bbShowDelete !== false) {
                $.extend(buttons, {
                    delete: {
                        "label" : "Delete",
                        "className" : "btn-danger",
                        "callback" : function() {
                            modals.delete(id, options.baseUrl);
                            return false;
                        }
                    }
                })
            }

            var bbOptions = Object.keys(options.data).reduce(function (result, key) {
                if (key.indexOf('bb') !== -1) {
                    var cleanKey = key.replace('bb', '');
                    cleanKey = cleanKey[0].toLowerCase() + cleanKey.slice(1);
                    result[cleanKey] = options.data[key];
                }
                return result;
            }, {});

            var modal = bootbox.dialog($.extend(bbOptions || {}, {
                message  : "Loading form...",
                title    : title,
                backdrop : "static",
                keyboard : false,
                show     : true,
                header   : title,
                buttons: buttons
            }));

            var reqParams = Object.keys(options.data).reduce(function (result, key) {
                if (key.indexOf('bb') === -1) {
                    result[key] = options.data[key];
                }
                return result;
            }, {});

            $.get(url, reqParams, function(data) {
                var result = $(data);
                var content = result.attr('id') === 'content' ? result : result.find('#content');
                modal.find('.modal-body').html(content);
                modal.find('.form-actions').hide();
                if (onLoad !== null && typeof onLoad !== 'undefined') { onLoad(); }
            });
        },
        create: function (title, baseUrl, exec, data) {
            modals.update(-1, title, baseUrl, exec, true, undefined, undefined, data);
        },
        update: function (id, title, baseUrl, exec, createMode, timeout, timeoutExec, data) {
            if (typeof id === 'object') id = id.id;
            var primaryBtnLabel = createMode ? 'Create' : 'Update';
            var url = createMode ? baseUrl + 'new' : baseUrl + id + '/edit';
            modals.form(id, title, primaryBtnLabel, url, exec, timeout, timeoutExec, { baseUrl: baseUrl, data: data });
        },
        other: function (id, title, baseUrl, actionName, exec, timeout, timeoutExec, data) {
            if (typeof id === 'object') id = id.id;
            var url = baseUrl + id + '/' + actionName;
            modals.form(id, title, actionName.charAt(0).toUpperCase() + actionName.slice(1), url, exec, timeout, timeoutExec, { baseUrl: baseUrl, data: $.extend({'bb-show-delete': false}, data) });
        },
        delete: function (id, baseUrl, exec) {
            bootbox.confirm('Are you sure?', function(result) {
                if (result === true) {
                    $.ajax({
                        url: baseUrl + id,
                        contentType: "application/javascript",
                        dataType: 'script',
                        type: 'DELETE'
                    }).success(function () {
                        if (typeof exec !== 'undefined') { exec(); }
                        BBCrud.Alert.show('Deleted');
                    }).error(function () {
                        BBCrud.Alert.show('Something went wrong!');
                    });
                }
            });
        },
        show: function(id, title, baseUrl, data) {
            var modal = bootbox.dialog($.extend(data.bb, {
                message  : "Loading form...",
                title    : title,
                backdrop : "static",
                keyboard : false,
                show     : true,
                header   : title,
                buttons: {
                    close: {
                        "label" : "Close"
                    }
                }
            }));
            $.get(baseUrl + id, function(result) {
                handleResponse(result);
            }).error(function (response) {
                if (response.status === 200) {
                    handleResponse(response.responseText);
                }
                console.log(response);
            });
            function handleResponse(response) {
                var result = $(response);
                var content = result.attr('id') === 'content' ? result : result.find('#content');
                modal.find('.modal-body').html(content);
            }
        },
        // general click handler displaying create or update form in modal
        initBtnHandler: function() {
            $(document).on('click', '[data-entity]', function() {
                var link = $(this);
                var args = $.extend({}, link.data());
                delete args['entity'];
                delete args['action'];
                BBCrud.Models[link.data('entity')][link.data('action')].call(link, args);
                return false;
            });
        }
    };
    return modals;
}());

BBCrud.Modals.initBtnHandler();

BBCrud.Models = (function () {
    function defineModelActions(modelName, actions) {
        if (typeof BBCrud.Models[modelName] === 'undefined') {
            BBCrud.Models[modelName] = actions;
        } else {
            $.extend(BBCrud.Models[modelName], actions);
        }
    }

    return {
        add: function(modelName, url, titleName) {
            var modelCRUD = (function () {
                var baseUrl = url;

                return {
                    new: function (data) {
                        BBCrud.Modals.create('Create ' + titleName, baseUrl, null, data);
                    },
                    edit: function (data) {
                        BBCrud.Modals.update(data.id, 'Edit ' + titleName, baseUrl, undefined, false, undefined, undefined, data);
                    },
                    show: function (data) {
                        BBCrud.Modals.show(data.id, titleName.charAt(0).toUpperCase() + titleName.slice(1) + ' detail', baseUrl, data);
                    }
                };
            }());

            defineModelActions(modelName, modelCRUD);
        },
        addAction: function(modelName, url, titleName, actionName) {
            var action = (function () {
                var baseUrl = url;
                var modelAction = {};
                modelAction[actionName] = function (data) {
                    BBCrud.Modals.other(data.id, actionName.charAt(0).toUpperCase() + actionName.slice(1) + ' ' + titleName,
                        baseUrl, actionName, null, 0, null, data);
                };
                return modelAction;
            }());
            defineModelActions(modelName, action);
        }
    };
}());


BBCrud.Alert = (function() {
    var elem,
        hideHandler,
        alert = {};

    alert.init = function(options) {
        elem = $(options.selector);
    };

    alert.show = function(text) {
        clearTimeout(hideHandler);

        elem.find("span").html(text);
        elem.fadeIn();

        hideHandler = setTimeout(function() {
            alert.hide();
        }, 4000);
    };

    alert.hide = function() {
        elem.fadeOut();
    };

    return alert;
}());

$(function() {
    BBCrud.Alert.init({selector: '.bb-alert'});
});
