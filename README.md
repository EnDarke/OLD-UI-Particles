# UI Particle System
### Description
- Creates and runs a 2D particle based off given input.
- You can emit in preset directions OR you can input your own value (IN DEGREES!)
- Emit multiple at once, OR Emit as many as you can over time!
- Defaulted to using scale for size and position. Size can be changed to offset if wanting.
- It is NOT necessary to input ALL of the particle information shown, there are defaults set.
- Will change to an image label IF an image is inputed.

### Preset Directions
- Top
- Bottom
- Left
- Right
- TopLeft
- TopRight
- BottomLeft
- BottomRight
- Scatter (All directions)

### Optional Particle Info Inputs
- AnchorPoint(Vector2)
- BackgroundTransparency(number)
- Position(UDim2)
- Size(UDim2)
- ZIndex(number)
- Image(string | e.g. "rbxassetid://NUMBERS)
- ImageColor3(Color3)
- BackgroundColor3(Color3)
- Lifetime(table | e.g. {MIN, MAX})
- Velocity(UDim2 | Starting velocity | UNNECESSARY)
- SpreadAngle(table | e.g. {MIN, MAX} | IN DEGREES)
- Direction(string or number | e.g. "Top" or 60 | NUMBER IN DEGREES)
- RotationSpeed(table | e.g. {MIN, MAX})
- Speed(table | e.g. {MIN, MAX})
- Acceleration(UDim2)
- TweenStyle(Enum.EasingStyle)
- TweenDirection(Enum.EasingDirection)
- RepeatCount(number)
- Reverses(boolean)
- DelayTime(number)
- ClearTweenProperties(table | e.g. {BackgroundTransparency = 1})
- SizeTweenProperties(table | e.g. {Size = UDim2.new(0, 0)})
- Parent(Instance | e.g. PlayerGui.ScreenGui)

### How to use
- Step One: Require the module
- Step Two: Create a new "UIParticles" object with the `UIParticles.new(particleInfo: table)` function.
- Step Three: Call the `UIParticles:Emit(count: number, FadeOut: boolean, SizeChange: boolean, timeBased: boolean, rate: number)` function with the necessary inputs.
- - count (number): If timeBased is false, count will be the amount emitted at **once.** If timeBased is true, count will be the amount of time the emission will go on for.
- - FadeOut (boolean): Will the particle tween it's transparency to invisible?
- - SizeChange (boolean): Will the particle tween it's size to grow or shrink (dependant on your tween inputs on particle creation)?
- - timeBased (boolean): If true, set count as the amount of time the emission will go on for and use `rate` as the amount emitted per second.
- - rate (number): If timeBased is true, this value will be the amount of particles emitted per second.
