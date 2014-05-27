#include <SFML/Graphics.hpp>
#include <string>
#include <cstdio>
#include <cstdlib>

using namespace sf;
using namespace std;

Texture* loadTexture(Texture* tex, string name)
{
    int i = tex->loadFromFile(name.c_str());
    if(i)
    {
        printf("Loaded Texture: \"%s\"\n", name.c_str());
        return tex;
    }
    else
    {
        printf("Error Loading Texture: \"%s\"\n", name.c_str());
        exit(0);
    }
}

int main(int argc, char* argv[])
{
    RenderWindow window(VideoMode(800, 600), "OpenTerra");
    
    Texture *tex;
    tex = loadTexture(tex, "res/grass.png");
    Sprite pellet;
    pellet.setTexture(*tex);
    
    while (window.isOpen())
    {
        // check all the window's events that were triggered since the last iteration of the loop
        Event event;
        while (window.pollEvent(event))
        {
            // "close requested" event: we close the window
            if (event.type == Event::Closed)
                window.close();
        }
        
        window.clear(Color::Black);
        
        window.draw(pellet);
        pellet.move(0.001f, 0.001f);
        
        window.display();
    }
    
    return 0;
}
