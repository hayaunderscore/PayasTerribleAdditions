# Full Credits to Firch for original code of this amazing sprite converter code so that 2x sprites don't look like they have glow :3

import sys, os
from PIL import Image
from PIL import ImageChops
import pathlib


asset_dir = str(pathlib.Path(__file__).parent.resolve()) + r""
input_dir = asset_dir + r"\1x"
upscale_dir = asset_dir + r"\2x"

def average_color_of_neighbors(img, x, y):
    width, height = img.size
    r_total, g_total, b_total, count = 0, 0, 0, 0

    neighbors = [(-1, -1), (0, -1), (1, -1),
                 (-1,  0),          (1,  0),
                 (-1,  1), (0,  1), (1,  1)]

    for dx, dy in neighbors:
        nx, ny = x + dx, y + dy
        if 0 <= nx < width and 0 <= ny < height:
            neighbor_pixel = img.getpixel((nx, ny))
            if neighbor_pixel[3] > 0:
                r_total += neighbor_pixel[0]
                g_total += neighbor_pixel[1]
                b_total += neighbor_pixel[2]
                count += 1

    if count > 0:
        return (r_total // count, g_total // count, b_total // count, 255)
    else:
        return (0, 0, 0, 0)

# https://stackoverflow.com/a/68402702
def are_images_equal(img1, img2):
    equal_size = img1.height == img2.height and img1.width == img2.width

    if img1.mode == img2.mode == "RGBA":
        img1_alphas = [pixel[3] for pixel in img1.getdata()]
        img2_alphas = [pixel[3] for pixel in img2.getdata()]
        equal_alphas = img1_alphas == img2_alphas
    else:
        equal_alphas = True

    equal_content = not ImageChops.difference(
        img1.convert("RGB"), img2.convert("RGB")
    ).getbbox()

    return equal_size and equal_alphas and equal_content

def process_image(path):
    img = Image.open(path).convert("RGBA")

    bottom_layer = img.copy()
    width, height = bottom_layer.size
    new_img = bottom_layer.copy()

    for y in range(height):
        for x in range(width):
            pixel = bottom_layer.getpixel((x, y))
            if pixel[3] == 0:
                new_color = average_color_of_neighbors(bottom_layer, x, y)
                new_img.putpixel((x, y), new_color)

    alpha = new_img.split()[3]
    alpha = alpha.point(lambda p: 0)
    new_img.putalpha(alpha)
    combined = Image.alpha_composite(new_img, img)

    return combined

def upscale_image(image, scale_factor=2):
    width, height = image.size
    new_size = (width * scale_factor, height * scale_factor)
    upscaled_image = image.resize(new_size, Image.NEAREST)
    return upscaled_image

def clear_directory(directory):
    print("Clearing directory: " + directory)

    for root, dirs, files in os.walk(directory, topdown=False):
        for name in files:
            os.remove(os.path.join(root, name))
        for name in dirs:
            os.rmdir(os.path.join(root, name))

def process_and_upscale(input_path, input_directory, upscale_directory):
    relative_path = os.path.relpath(input_path, input_directory)
    output_path = os.path.join(upscale_directory, relative_path)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    print("Processing image: " + input_path)
    processed_image = process_image(input_path)
    # processed_image.save(output_path, "PNG")
    
    upscaled_image = upscale_image(processed_image)
    try:
        currently_upscaled = Image.open(output_path).convert("RGBA")
        if currently_upscaled and are_images_equal(currently_upscaled, upscaled_image):
            print("Upscaled images are the same. Skipping...")
            return
    except:
        print("Upscaling image: " + output_path)
    upscaled_image.save(output_path, "PNG")

def process_directory(input_directory, upscale_directory):
    print("Processing directory: " + input_directory)

    # clear_directory(upscale_directory)

    for root, _, files in os.walk(input_directory):
        for file in files:
            input_path = os.path.join(root, file)
            process_and_upscale(input_path, input_directory, upscale_directory)

if __name__ == "__main__":
    print("Script start")
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        process_and_upscale(file_path, input_dir, upscale_dir)
    else:
        process_directory(input_dir, upscale_dir)
    print("Script end")
