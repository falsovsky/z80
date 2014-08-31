#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <SDL/SDL.h>
#include <windows.h>

#define READ_BIT(x,n) (x>>n)&1

/* The screen surface */
SDL_Surface *screen = NULL;

#define BUFFER_SIZE 32
unsigned char buffer[192][BUFFER_SIZE];


int order[191] = {
     0, 8, 16, 24, 32, 40, 48, 56,
     1, 9, 17, 25, 33, 41, 49, 57,
    2, 10, 18, 26, 34, 42, 50, 58,
    3, 11, 19, 27, 35, 43, 51, 59,
    4, 12, 20, 28, 36, 44, 52, 60,
    5, 13, 21, 29, 37, 45, 53, 61,
    6, 14, 22, 30, 38, 46, 54, 62,
    7, 15, 23, 31, 39, 47, 55, 63,
    
//  64, 72, 80, 88, 96, 104, 112, 120,
//  65, 73, 81, 89, 97, 105, 113, 121,
//  66, 74, 82, 90, 98, 106, 114, 122,
//  67, 75, 83, 91, 99, 107, 115, 123,
};

//int order[191];
int pos = 0;

void add_item(int item)
{
     order[pos] = item;
     pos++;
}

void set_order() {
     int i,z;

     // First third of the screen
     for (i = 0; i <= 7; i++) {
         for (z = 0; z <= 7; z++) {
             add_item(i + z*8);
         }
     }

     // Second third of the screen
     for (i = 65; i <= 72; i++) {
         for (z = 0; z <= 7; z++) {
             add_item(i + z*8);
         }
     }

}

/* This function draws to the screen; replace this with your own code! */
static void
draw ()
{
    SDL_Rect rect;
    Uint32 color;
    int b,i,z,y;
    
    unsigned char c;

    /* Create a black background */
    color = SDL_MapRGB (screen->format, 0, 0, 0);
    SDL_FillRect (screen, NULL, color);
    
    color = SDL_MapRGB (screen->format, 255, 255, 255);

    for (b = 0; b <= 191; b++) { // Y
        y = order[b];
        for (i = 0; i <= 31; i++) { // X
            c = buffer[y][i];
            for (z = 7; z >= 0; z--) { // Position in X byte
                if (READ_BIT(c,z)) {
                   rect.w = 1;
                   rect.h = 1;
                   rect.x = (i*8-z)+8;
                   rect.y = b;
                   SDL_FillRect (screen, &rect, color);
                }
            }
        }
    }

    /* Make sure everything is displayed on screen */
    SDL_Flip (screen);
}


int
main (int argc, char *argv[])
{
    char *msg;
    int done;
    int i;
    FILE *file_ptr;

    /* Initialize SDL */
    if (SDL_Init (SDL_INIT_VIDEO) < 0)
    {
        sprintf (msg, "Couldn't initialize SDL: %s\n", SDL_GetError ());
        MessageBox (0, msg, "Error", MB_ICONHAND); 
        free (msg);
        exit (1);
    }
    atexit (SDL_Quit);

    screen = SDL_SetVideoMode (256, 192, 16, SDL_SWSURFACE | SDL_DOUBLEBUF);
    if (screen == NULL)
    {
        sprintf (msg, "Couldn't set 640x480x16 video mode: %s\n",
          SDL_GetError ());
        MessageBox (0, msg, "Error", MB_ICONHAND); 
        free (msg);
        exit (2);
    }
    SDL_WM_SetCaption ("SDL MultiMedia Application", NULL);

    file_ptr = fopen("MagiclandDizzy.scr", "r");

    for(i = 0; i <= 192; i++) {
          fread(buffer[i], sizeof(unsigned char), BUFFER_SIZE, file_ptr);
    }
    //set_order();

    done = 0;
    while (!done)
    {
        SDL_Event event;

        /* Check for events */
        while (SDL_PollEvent (&event))
        {
            switch (event.type)
            {
            case SDL_KEYDOWN:
                break;
            case SDL_QUIT:
                done = 1;
                break;
            default:
                break;
            }
        }

        /* Draw to screen */
        draw ();
    }

    return 0;
}
