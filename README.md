# ShapeDraw
A simple shape drawing and editing app.

The base class for the shapes is the `SDShape` class. It is a container for the `UIBezierPath` that each of its subclasses generate in their own way. Other than `UIBezierPath` they do not depend on any `UIKit` entities.

Shapes are created using the static class `SDShapeFactory`. It is an implementation of the classic abstract factory pattern, so that none of the subclasses of `SDShape` need to be exposed and all shapes can be handled in the same way. Adding new shape types is as simple as adding a new `SDShape` subclass, adding a case to the `SDShapeType` enum and adding to the `supportedShapeTypes` and `create` methods of the factory. 

The class responsible for showing the shapes is `SDShapeView`, a subclass of `UIView`. The edit operations (translate, rotate and scale) are partitioned off into extensions of `SDShapeView`. Each of these operations is implemented using `UIPanGestureRecognizer` on a small anchor view (one per edit operation). Note that the operations are performed on the `UIBezierPath` and not on the view showing it. The view only scales with the bounds of the `UIBezierPath`, when needed. The main reason for this is that I did not want to keep any state inside the views, other than the `SDShape`s themselves, with an eye on possible serialization/deserialization of the shapes. In other words, it should be possible to save/load the entire drawing as a list of `SDShape`.

The app uses a single view controller, `SDViewController`.  Including extensions for `UITableViewDataSource` and `UITableViewDelegate` it is under 200 lines and I saw no need to split it up and use a more advanced pattern than MVC (such as, for example, MVVM). In the interest of time efficiency I kept the UI as simple and plain as possible (also, I'm not a graphic designer ;-) )

The functionality implemented is:

- Create new shape ('New' button on the top right)
- Name new shape (name needs to be unique, if no name is entered, an auto-generated name is used)
- Toggle visibility (use switch in the table view cell)
- Edit shape (select from the table view)
- Translate (center edit anchor on edited shape)
- Rotate (top center edit anchor on edited shape)
- Scale (bottom right edit anchor on edited shape)
- Delete (swipe left on the table view cell)

Ideas for improvements:

- Allow reordering the tableview to edit the shape view order (now the first one is on the bottom and the last one is on top)
- Fix the positioning of the edit anchors during editing (it is buggy now, I put in a workaround where the positions are reset after editing)
- The editing code could be structured better, there is some very similar code in the translate/rotate/scale parts that could probably be abstracted out of the `SDShapeView`
- Let the user edit common shape attributes (e.g., pick the fill and stroke colors of the shapes, which are randomized at the moment)
- Allow the user to edit shape-specific attributes (e.g., the corner radius on the rounded rectangle or the number of points on a star, number of vertices on a polygon, etc.)
- Saving/loading the drawing


Total time spent: around 8 hours
