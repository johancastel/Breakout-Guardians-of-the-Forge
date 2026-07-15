import os
from PIL import Image, ImageDraw, ImageFont

def draw_uml():
    # Size and background
    width, height = 1200, 850
    img = Image.new("RGB", (width, height), (255, 255, 255))
    draw = ImageDraw.Draw(img)
    
    # Load Font
    try:
        font_title = ImageFont.truetype("arial.ttf", 13)
        font_text = ImageFont.truetype("arial.ttf", 11)
        font_bold = ImageFont.truetype("arialbd.ttf", 11)
    except IOError:
        font_title = ImageFont.load_default()
        font_text = ImageFont.load_default()
        font_bold = ImageFont.load_default()

    def draw_class(name, x, y, w, h, attributes, methods, is_new=False):
        # Colors
        bg_color = (230, 255, 230) if is_new else (255, 255, 255)
        border_color = (30, 100, 30) if is_new else (0, 0, 0)
        border_width = 2 if is_new else 1
        
        # Draw background rectangle
        draw.rectangle([x, y, x + w, y + h], fill=bg_color, outline=border_color, width=border_width)
        
        # Class Header
        title_text = f"<<nuevo>> {name}" if is_new else name
        # Center class title
        title_w = draw.textlength(title_text, font=font_title)
        draw.text((x + (w - title_w)/2, y + 8), title_text, fill=(0,0,0), font=font_bold)
        
        # First separator line
        draw.line([x, y + 28, x + w, y + 28], fill=border_color, width=1)
        
        # Attributes
        curr_y = y + 33
        for attr in attributes:
            draw.text((x + 10, curr_y), attr, fill=(0,0,0), font=font_text)
            curr_y += 15
            
        # Second separator line
        draw.line([x, y + h - (len(methods) * 15 + 10), x + w, y + h - (len(methods) * 15 + 10)], fill=border_color, width=1)
        
        # Methods
        curr_y = y + h - (len(methods) * 15 + 5)
        for meth in methods:
            draw.text((x + 10, curr_y), meth, fill=(0,0,0), font=font_text)
            curr_y += 15

    # 1. Draw Classes
    # Game
    draw_class("Game", 420, 420, 200, 140, 
               ["+score : int", "+lives : int", "+level : int"], 
               ["+update(dt)", "+draw()"])
               
    # StateMachine (New)
    draw_class("StateMachine", 100, 420, 200, 140,
               ["+states : table", "+current : State"],
               ["+switch(name, ...)", "+update(dt)", "+draw()", "+keypressed(k)"], is_new=True)

    # Collision (New)
    draw_class("Collision", 420, 240, 200, 110,
               [],
               ["+aabb(a, b) : bool", "+resolveBallBrick(ball, brick)"], is_new=True)

    # Ball
    draw_class("Ball", 100, 210, 200, 155,
               ["+x, y, w, h : float", "+vx, vy : float", "+maxVx : float"],
               ["+update(dt)", "+bounceOnPaddle(p)", "+reset(x, y)"])

    # Paddle
    draw_class("Paddle", 100, 640, 200, 120,
               ["+x, y, w, h : float", "+speed : float"],
               ["+update(dt)", "+draw()"])

    # Level
    draw_class("Level", 420, 640, 200, 120,
               ["+bricks : Brick[]"],
               ["+load(layout)", "+draw()", "+isCleared() : bool"])

    # Brick
    draw_class("Brick", 740, 420, 200, 130,
               ["+x, y, w, h : float", "+_dead : bool"],
               ["+onHit() : int", "+draw()"])

    # StrongBrick (New)
    draw_class("StrongBrick", 740, 240, 200, 110,
               ["+_hp : int"],
               ["+onHit() : int"], is_new=True)

    # UnbreakableBrick (New)
    draw_class("UnbreakableBrick", 990, 420, 180, 100,
               [],
               ["+onHit() : int", "+draw()"], is_new=True)

    # PowerUp (New)
    draw_class("PowerUp", 740, 640, 200, 125,
               ["+x, y, vy : float", "+efecto : function", "+_dead : bool"],
               ["+update(dt)", "+draw()"], is_new=True)

    # 2. Draw Relationships (Connectors)
    # Helper to draw arrows/shapes
    def draw_diamond(cx, cy, direction="left"):
        # Composition Diamond (solid black)
        r = 6
        if direction == "left":
            pts = [(cx, cy), (cx + r, cy - r), (cx + 2*r, cy), (cx + r, cy + r)]
        elif direction == "right":
            pts = [(cx, cy), (cx - r, cy - r), (cx - 2*r, cy), (cx - r, cy + r)]
        elif direction == "bottom":
            pts = [(cx, cy), (cx - r, cy - r), (cx, cy - 2*r), (cx + r, cy - r)]
        elif direction == "top":
            pts = [(cx, cy), (cx - r, cy + r), (cx, cy + 2*r), (cx + r, cy + r)]
        draw.polygon(pts, fill=(0,0,0), outline=(0,0,0))
        return r*2

    def draw_triangle(cx, cy, direction="top"):
        # Inheritance Triangle (white fill, black outline)
        r = 8
        if direction == "top":
            pts = [(cx, cy), (cx - r, cy + r), (cx + r, cy + r)]
        elif direction == "left":
            pts = [(cx, cy), (cx + r, cy - r), (cx + r, cy + r)]
        draw.polygon(pts, fill=(255,255,255), outline=(0,0,0), width=1)
        return r

    def draw_arrow(cx, cy, direction="right"):
        # Simple open arrowhead
        r = 6
        if direction == "right":
            draw.line([cx, cy, cx - r, cy - r], fill=(0,0,0), width=1)
            draw.line([cx, cy, cx - r, cy + r], fill=(0,0,0), width=1)
        elif direction == "bottom":
            draw.line([cx, cy, cx - r, cy - r], fill=(0,0,0), width=1)
            draw.line([cx, cy, cx + r, cy - r], fill=(0,0,0), width=1)

    # Game *-- StateMachine (Left)
    draw_diamond(420, 490, "left")
    draw.line([420 - 12, 490, 300, 490], fill=(0,0,0), width=1)
    
    # Game *-- Ball (Top Left)
    draw_diamond(420, 440, "left")
    draw.line([420 - 12, 440, 360, 440], fill=(0,0,0), width=1)
    draw.line([360, 440, 360, 310], fill=(0,0,0), width=1)
    draw.line([360, 310, 300, 310], fill=(0,0,0), width=1)

    # Game *-- Paddle (Bottom Left)
    draw_diamond(420, 540, "left")
    draw.line([420 - 12, 540, 360, 540], fill=(0,0,0), width=1)
    draw.line([360, 540, 360, 680], fill=(0,0,0), width=1)
    draw.line([360, 680, 300, 680], fill=(0,0,0), width=1)

    # Game *-- Level (Bottom)
    draw_diamond(520, 560, "bottom")
    draw.line([520, 560 + 12, 520, 640], fill=(0,0,0), width=1)
    
    # Level *-- Brick (Right)
    draw_diamond(620, 700, "right")
    draw.line([620 - 12, 700, 680, 700], fill=(0,0,0), width=1)
    draw.line([680, 700, 680, 515], fill=(0,0,0), width=1)
    draw.line([680, 515, 740, 515], fill=(0,0,0), width=1)
    
    # Brick <|-- StrongBrick (Top)
    draw_triangle(840, 350, "top")
    draw.line([840, 350 + 8, 840, 420], fill=(0,0,0), width=1)
    
    # Brick <|-- UnbreakableBrick (Right)
    draw_triangle(940, 470, "left")
    draw.line([940 + 8, 470, 990, 470], fill=(0,0,0), width=1)

    # Game ..> Collision (Top)
    draw.line([520, 420, 520, 350], fill=(0,0,0), width=1)
    draw_arrow(520, 350, "top")

    # Brick ..> PowerUp (Bottom)
    # Dashed line
    for curr_y in range(550, 640, 8):
        draw.line([840, curr_y, 840, min(curr_y + 4, 640)], fill=(0,0,0), width=1)
    draw_arrow(840, 640, "bottom")

    # Save PNGs
    os.makedirs("01_docs/03_UML", exist_ok=True)
    img.save("01_docs/03_UML/Diagrama_juego.png")
    img.save("01_docs/03_UML/Diagrama_juego_delta.png")
    print("PNG diagrams generated successfully in 01_docs/03_UML/")

if __name__ == "__main__":
    draw_uml()
