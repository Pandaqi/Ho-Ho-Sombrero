# \[Idea\] In Eggcelent Condition

**BETTER TITLE => Ho Ho Sombrero? =>** Combines *Christmas* and *Sombreros*

Key elements:

-   Local cooperative multiplayer for **1-X players**.

-   Extremely simple. (Only moving. Extra button is optional.)

-   Just need to keep things in the air (touching the ground will break them).

-   To remove them from the air, *deliver* them safely somewhere.

## Positivity & Wholesomeness

How to really make this a core part of the game?

-   You can only go *forward*. Breaking eggs isn't bad or game over => it just gives you a powerup to help you next time.

-   Each egg stands for some *wish* or *desire* or *dream*.

-   When the game is over, all eggs explode and little birds come out?

-   You're helping Santa Claus deliver presents?

-   Any *time* you set is good. (Though you can always improve if you want, or enable stricter rules in the settings.)

## Powerups

Are the same as eggs.

-   When you *break* an egg, it reveals its powerup, so you can grab it.

-   When you *deliver* an egg, you just get its points, counting towards objective.

At the same time, **powerups are your second button.** (Which also means they are displayed + their button on players.)

Others are just temporary status effects ( "faster speed") or global effects ("slower eggs")

## Obstacles

There can be extra elements in the level. These are meant for:

-   (Visual) variation => a flat, plain, empty rectangle isn't great

-   Helping you => pillows to catch stuff, ramps to deflect eggs back at you

-   Hindering you => stuff to walk around, weird deflections on eggs

## Egg Cannons

These *shoot* the eggs into the level. Only when they get the signal (and know an egg is needed).

They slowly rotate (and pick a random force) to *vary* where eggs end up.

## Collision Layer

1.  All

2.  Eggs

3.  Players

4.  Environment

**Remark:** Sombreros are only on layer 2, so they don't collide with terrain or other players. (Was just too frustrating and annoying, you could never reach anything.)

## 3D Models

Websites:

-   <https://poly.pizza>

-   

Reddit post by someone with a *huge* amount of free asset packs:

-   <https://www.reddit.com/r/gamedev/comments/rih967/ive_made_a_pack_with_everything_you_need_to_make/>

Proper tutorial for making a (cuter, more proportional) reindeer: <https://www.youtube.com/watch?v=DQU4wYtggCw>

# Future To Do

## Gameplay

-   An actual loss condition (or more interesting win condition). Due to the jam being about positivity, there is no way to lose and breaking eggs is actually quite a good thing. But that *does* destroy much of the challenge ...

-   Additional "rules" or "player roles" within the game to add **more control** over eggs.

    -   Maybe some general powerup or lever that can be pulled, which grants all players the power to *hold* eggs ( = stick to their sombrero) for 10 seconds.

    -   You can time when you use it, so all players get the most out of it.

## UI

-   Better UI, sprites, and helpers to show the *type* of an egg or powerup. And where it is or where it's going to come from.

-   Modify the egg UVs a bit so the *center pattern* isn't squashed and stretched this much? => would make it easier to see what's what.

-   Add a **setting** for "performance mode" => this (among other things) disables the egg painting texture

## Polish

-   Make the default egg size slightly bigger.

-   An actual material/effect for when an egg is delivered

-   Specific sound effects per powerup -- especially those you can consciously *use*. (For example: jumping needs different fx than dashing.)

-   Add explosion to the bomb effect

-   Ice Movement => not a great implementation at the moment, but don't really see a better way now ...

-   Create a simple player character (with a huge moustache).

-   Try moving the second player with the *right joystick* on controller. (Would require adding an extra entry to the input map with some made-up number that will never be reached in real-life.)

-   The eggs, somehow, stopped rotating with the shot vector in *egg cannons*? (Because of the reparenting for bounce animation?)

-   Missing some sound effects (e.g. player switch on joystick), particles and feedback.

-   Prettier main menu. (More contained environment, instead of just empty space around it.)

## Arenas

**Big thing #0:** Make arenas **BIGGER** and **ROUND.** (The increased size of the snow arena feels nice. If making things circular is too much, just make the level more like a hexagon or an octagon. Would already prevent most corner issues.)

> **YES, THIS IS THE PLAN:** Sombrero for ground, Egg-shaped dome for boundaries
>
> **Arena Idea:** two eggs next to each other => one spawns the eggs, then you use a bridge to walk to the other, to deliver it
>
> **MENU =>** make a bunch of eggs hanging in the air, each egg holds *one* level on top of it. Once played, it opens the gate/bridge to the next egg.
>
> Removes the need for lots of environment around the menu. Also clearer separation and more thematical with the new way levels will be.

**Big thing #1:** give players a way to combat that big space. Move faster, teleporters, keep eggs safe, delay the arrival of eggs (by turning off a cannon, for example)

Removing some of these "helpers", or closing the space more with obstacles, would scale it for different player counts.

**Big thing #2:** Movable obstacles within the level: ramps to deflect eggs, pillows to catch them before they break, a bowl to just collect eggs.

**Big thing #3:** More life and variation to the arenas. (The models there are only *bare bones*. The essentials for functionality. None of it moves or is animated. Only a few variations.)

**Specifics:**

-   Forest: create more trees + polish + ... grass?

-   Desert: are colors too bright?

-   North Pole: a bit too bland (just plain white) now

    -   Also, add more ramps towards the sleigh at the bottom. Really hard to get there now, and many eggs break on that flat part inside the bounds

-   Cuddly Clouds: laggy?

-   Some egg-shaped rocks or statues throughout?

## Ideas

**IDEA:** Some baskets accept anything. Others only accept specific eggs (show with icons on their side).

**IDEA:** Some powerup that makes eggs stick to you, so you're literally carrying them. Or this might a "player role" => you can collect eggs and keep them safe.

-   Someone else must come and bump them off you?

-   Or your button is permanently used for shooting them away?

# Powerups

## Button-based

-   X Jump

-   X Dash = quick speed burst in a direction

-   X Magnet/Repel = attract/repel all eggs within a certain radius

-   X Freeze = completely freeze all eggs within a certain radius

-   X Levitate = you and everyone nearby levitates ( = reverse gravity)

-   X Frisbee = you can *throw* your sombrero (and it will come back to you like a boomerang?)

## General

-   X Earthquake = Your sombrero is slanted sideways

-   X Frying Pan = Your sombrero is mounted at your *side* (half height), instead of on your head

-   X Move faster/slower

-   X Move like you're on ice

-   X Bounciness plus/min = eggs bounce more or less on your head

-   X One or two eggs that do *nothing special*, just to keep it simple.

-   X An egg that is always worth 2 points/0 points

-   X One that's worth as many points as *the number of players it has touched* => needs functionality

-   X One that explodes when it breaks, blowing away all eggs and players nearby?

## Global

-   X Lower/Higher gravity

-   X Faster/slower moving eggs

-   X Eggs are worth double their points/half their points

-   X Eggs are bigger/smaller from now on

## Future

-   Smaller sombrero => need to create a *separate* smaller version of the collision shapes and a system to swap them out

-   One that *converts* itself into a pillow when it lands? => first need pillows and general "environment obstacles" for that

## Discarded Ideas

-   An egg that grows *smaller/bigger* over time => can't really do that with physics, especially when it's so important and constantly interacting. Also don't see the point, as there's no fixed "end" to an egg's life. (Unlike the growing balls in Totems of Tag, which stop once they run out of speed.)

# Arenas

## Magical Forest

**Look?** Relatively flat grassland, (dark) green and brownish colors. Lots of trees and grass.

**Edges?** Tall trees, going higher and higher.

**Special rule?** None, it's the first arena.

**Delivering?** Egg baskets.

## Dancing Desert

**Look?** Yellowy, green cacti scattered, some sandy hills

**Edges?**

**Special rule?** None.

**Delivering?** Birds fly overhead; these accept your eggs if they come near enough.

## Christmas City

**Look?** Variety of colors. Buildings, market stalls, etcetera scattered around roads. Nighttime, Christmas lights, big Christmas tree in center of town square?

**Edges?** Buildings.

**Special rule?**

**Delivering?** Egg baskets.

## North Pole

**Look?** White, lightblue, snow and ice everywhere.

**Edges?** The factories/buildings from Santa Claus?

**Special rule?** All movement is slidy-slidy :p

**Delivering?** Multiple sleighs are on stand-by. When filled once (or X times), they fly off, and a new one will arrive somewhere else (from the sky).

## Easter Island

**Look?** An island (some grass, some beach, some rocky stuff => water around it) And, of course, those big Easter heads.

**Edges?** Around the water.

**Special rule?** Anything that lands in the water is dragged with the current. (Though, how does it ever get *up* again?)

> Perhaps better: anything that ends in the water, is shot back into the level via the "big easter head" after several seconds.

**Delivering?** The Easter heads open their mouth => get an egg in there.

## Cuddly Clouds

**Look?** You're in the clouds. Around you, there are these *huge* storks holding a towel in their beak.

**Edges?** The storks block it in quite well. Otherwise, there are way more clouds around you?

**Special rule?**

**Delivering?** Get the egg in a towel a stork is holding.

## Misc

**Delivery idea =** hoops in the air (like Quidditch), or holes in the ground?

> Maybe if it enters a *hole*, it simply comes back somewhere else? (It's not delivered, but it's also not broken.)

# Obstacles

## Visual

Although they can have a gameplay impact, they're mostly for environment and visual flair.

-   Trees

-   Rocks

These can be static (in low numbers).

But they are mostly *dynamic*: popping up, then disappearing against after some time.

## Physics

These give a great deal of extra options, deflections, movement, etcetera.

-   A (low) trampoline to move around, which can either help you jump, or save an egg from falling

-   Same with a *pillow*

-   A *ramp* that deflects the eggs.
