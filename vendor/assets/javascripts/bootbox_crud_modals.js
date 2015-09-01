var BBCrud = BBCrud || {};

BBCrud.Modals = function () {

    var modals = {
        form: function(id, title, btnLabel, url, exec, timeout, timeoutExec, options) {
            var buttons = {
                close: {
                    "label" : "Close"
                },
                submit: {
                    "label" : btnLabel,
                    "className" : "btn-success",
                    "callback": function() {
                        if (options.dontSubmit !== true) {
                            $('.bootbox.modal').find('input[type="submit"]').closest('form').submit();
                        }
                        if (timeoutExec !== null && typeof timeoutExec != 'undefined') { setTimeout(timeoutExec, timeout); }
                        return false;
                    }
                }
            };
            if (id !== -1 && options.showDeleteBtn !== false) {
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

            var modal = bootbox.dialog({
                message  : "Loading form...",
                title    : title,
                backdrop : "static",
                keyboard : false,
                show     : true,
                header   : title,
                buttons: buttons
            });
            $.get(url, options.data, function(data) {
                var result = $(data);
                var content = result.attr('id') === 'content' ? result : result.find('#content');
                modal.find('.modal-body').html(content);
                modal.find('.form-actions').hide();
                if (exec !== null && typeof exec != 'undefined') { exec(); }
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
            modals.form(id, title, actionName.charAt(0).toUpperCase() + actionName.slice(1), url, exec, timeout, timeoutExec, { baseUrl: baseUrl, data: data, showDeleteBtn: false });
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
                            if (typeof exec != 'undefined') { exec(); }
                            BBCrud.Alert.show('Deleted');
                        }).error(function () {
                            BBCrud.Alert.show('Something went wrong!');
                        });
                }
            });
        },
        show: function(id, title, baseUrl) {
            var modal = bootbox.dialog({
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
            });
            $.get(baseUrl + id, function(data) {
                handleResponse(data);
            }).error(function (response) {
                if (response.status === 200) {
                    handleResponse(response.responseText);
                }
                console.log(response);
            });
            function handleResponse(data) {
                var result = $(data);
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
                BBCrud[link.data('entity')][link.data('action')].call(link, args);
                return false;
            });
        }
    };
    return modals;
}();

BBCrud.Modals.initBtnHandler();

BBCrud.Models = function () {
    function defineModelActions(modelName, actions) {
        if (typeof BBCrud[modelName] === 'undefined') {
            BBCrud[modelName] = actions;
        } else {
            $.extend(BBCrud[modelName], actions);
        }
    }
    
    var models = {
        add: function(modelName, url, titleName) {
            var modelCRUD = function () {
                var baseUrl = url;

                var methods = {
                    create: function (data) {
                        BBCrud.Modals.create('Create ' + titleName, baseUrl, null, data);
                    },
                    update: function (data) {
                        BBCrud.Modals.update(data.id, 'Edit ' + titleName, baseUrl);
                    },
                    show: function (data) {
                        BBCrud.Modals.show(data.id, titleName.charAt(0).toUpperCase() + titleName.slice(1) + ' detail', baseUrl);
                    }
                };
                return methods;
            }();

            defineModelActions(modelName, modelCRUD);
        },
        addAction: function(modelName, url, titleName, actionName) {
            var action = function () {
                var baseUrl = url;
                var modelAction = {};
                modelAction[actionName] = function (data) {
                    BBCrud.Modals.other(data.id, actionName.charAt(0).toUpperCase() + actionName.slice(1) + ' ' + titleName,
                        baseUrl, actionName, null, 0, null, data);
                };
                return modelAction;
            }();
            defineModelActions(modelName, action);
        }

    };
    return models;
}();


BBCrud.Alert = function() {
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
}();

$(function() {
   BBCrud.Alert.init({selector: '.bb-alert'});
});
