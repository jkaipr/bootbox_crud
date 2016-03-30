describe("BBCrud.Models", () => {
  it("BBCrud.Models is defined", () => {
    expect(BBCrud.Models).toBeDefined();
    expect(BBCrud.Models.add).toBeDefined();
    expect(BBCrud.Models.addAction).toBeDefined();
  });
});

describe("BBCrud.Models.add", () => {
  it("Creates new model object on BBCrud.Models", () => {
    BBCrud.Models.add('Box', '/boxes/', 'box');
    expect(BBCrud.Models.Box).toBeDefined();
    expect(BBCrud.Models.Box.new).toBeDefined();
    expect(BBCrud.Models.Box.edit).toBeDefined();
    expect(BBCrud.Models.Box.show).toBeDefined();
  });
});

describe("BBCrud.Models.addAction", () => {
  it("Creates a new model, if it wasn't previously defined and adds a function to it", () => {
    BBCrud.Models.addAction('Sphere', '/spheres/', 'sphere', 'tessellate');
    expect(BBCrud.Models.Sphere).toBeDefined();
    expect(BBCrud.Models.Sphere.tessellate).toBeDefined();
  });
});
