# CollisionVisualizer
A Roblox plugin to visual CanCollide, CanQuery and CanTouch

# Background
While building a game, it’s a good idea to optimize things to reduce the workload on the engine for handling collisions and touch events by setting CanCollide (and now CanQuery, and CanTouch properties within your parts.

The problem is there’s no really good way to visualize those properties within studio. And, if you have a big build (for example, my game has 4,700 parts and 79,000+ instances), it’s really hard to do a thorough job, and working from a script is just as hard because you have to go line by line and find each part.

So, I created this tool to visualize parts based on their properties. It was loosely patterned off of CloneTrooper1019’s Collision Groups plugin (just so I could see how to do selection boxes easily).

Here’s how it works…
When you run the plugin, it gives you a selection box for selecting the property you want to visualize.

There are three choices:

* CanCollide - Highlights all parts with CanCollide = true
* CanQuery - Highlights all parts where CanQuery = true AND CanCollide = false (Helpful for finding those parts where you’ve already turned off collision and want to take advantage of the new CanQuery functionality)
* CanTouch - Highlights all the parts with CanTouch = true

Here are examples of the three settings in a room within my game:
![image](https://user-images.githubusercontent.com/82744105/134177673-be89e219-e68d-4450-91ea-1a565feae9a7.png)

![image](https://user-images.githubusercontent.com/82744105/134177718-88e9b9b9-3a90-475a-875f-15f9d8ca7e7d.png)

![image](https://user-images.githubusercontent.com/82744105/134177745-ee34f881-db0b-44a0-a110-15aba2df6b31.png)

From the above I can see that I have some parts where I need to turn CanQuery off, and I see that the overhead lights have both collision and CanTouch on, and I can turn those off.

# Usage Notes:

To save compute cycles, all selection box refreshing is done when you make a new selection in the GUI. So if you move the camera somewhere else just turn one of the options to “ON” and the selection boxes will refresh in the new view. If you change the property of the part, you’ll need to un-select it and then cycle the option again to refresh the selection boxes.

No, you can’t select more than one option at a time. This is to prevent having to have complex logic in the plugin to display multiple criteria at once given only two view properties (selection box interior color and frame color). If there is enough demand I may consider doing something extra here.

Here’s a link to the plugin:

https://devforum.roblox.com/t/visualize-cancollide-canquery-and-cantouch/1475786/1

# UPDATE:

After using my own plugin to go through my game and clean out all of the CanQuery properties on parts where CanCollide is off, I found out that Studio is not saving these changes. I verified this by writing a simple script to set all CanQuery properties to false where CanCollide is already false. My plugin showed that no parts had CanQuery as true. I closed and re-opened Studio. All of my parts were once again set to CanQuery == true.

Hopefully Roblox will fix this issue so that everyone can actually use it…
