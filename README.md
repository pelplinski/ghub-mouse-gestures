# Logitech G HUB Mouse Gestures

This project adds mouse gesture support to Logitech G HUB, bringing functionality similar to the gesture system available in Logitech Options+ on devices such as MX Master, MX Anywhere, and M720 Triathlon.
<img width="600" alt="options+ gestures" src="https://github.com/user-attachments/assets/90354f32-4a10-4ab6-8f8d-b035912ae4d6" />


It is intended for Logitech Gaming mice like the G502 X, where hardware quality and button count are excellent, but gesture support is missing in the official software.
## Motivation
I really enjoy mouse gestures in Options+, especially on devices like MX Master, MX Anywhere, or M720 Triathlon. After switching to the G502 X Plus, which is a much lighter mouse with more buttons and great ergonomics, I was surprised that G HUB does not offer a comparable gesture feature.

This script was created to fill that gap.

The goal was to recreate the gesture experience from Options+ while keeping full flexibility of G HUB. The script is lightweight, easy to customize, and designed to be adapted to individual workflows.

<img width="600" alt="GHUB" src="https://github.com/user-attachments/assets/b91e7d52-89bf-45e0-9531-d325625f80d9" />

## What Can Be Achieved Using This Script and G HUB Options
- Gesture-based control using any mouse button
- Directional gestures (up, down, left, right) and click detection
- Execution of:
  - Keyboard shortcuts  
  - Mouse clicks
  - G HUB macros  
  - Custom Lua logic
- Optional DPI shift while a gesture is active, either through:
  - A macro triggered on gesture start and released on gesture end, or  
  - Direct DPI Shift assignment in device settings
 
## Recommended Options

For best experience, it is recommended to assign either:

- **Disabled**, or  
- A temporary **DPI Shift**

to the mouse button used for gestures in Logitech G HUB device settings. This prevents the button’s default action from interfering while performing gestures.

## Installation 

1. Open **Logitech G HUB**  
2. Go to **Profiles**  
3. Select your profile and click the three dots menu  
4. Choose **Create LUA Script**  
5. Paste the contents of [ghub-mouse-gestures.lua](ghub-mouse-gestures.lua)
6. Adjust the options in the script to your needs
7. Click **Script -> Save & Run**

<img width="600" alt="g-hub lua script" src="https://github.com/user-attachments/assets/a113a70b-265a-4005-8583-9c6d3df7dfdb" />


