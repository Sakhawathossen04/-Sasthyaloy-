import os
from PIL import Image

def main():
    src_icon = r"C:\Users\User\.gemini\antigravity\brain\d3769d1c-0961-4e4c-b293-047ae7a658eb\sasthyaloy_clean_1024_v2.png"
    base_dir = r"D:\AI Project\Medical Project\Code"
    assets_icon_dir = os.path.join(base_dir, "assets", "icon")
    os.makedirs(assets_icon_dir, exist_ok=True)

    img = Image.open(src_icon).convert("RGBA")

    # 1. Save master app_logo.png
    master_path = os.path.join(assets_icon_dir, "app_logo.png")
    img.save(master_path, "PNG")
    print("Saved master app_logo.png:", master_path)

    # 2. Standard launcher icon sizes
    densities = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }

    # 3. Adaptive icon foreground sizes
    fg_densities = {
        "mipmap-mdpi": 108,
        "mipmap-hdpi": 162,
        "mipmap-xhdpi": 216,
        "mipmap-xxhdpi": 324,
        "mipmap-xxxhdpi": 432,
    }

    # Generate both into android/app/src/main/res and assets/icon/res
    targets = [
        os.path.join(base_dir, "android", "app", "src", "main", "res"),
        os.path.join(assets_icon_dir, "res"),
    ]

    for target in targets:
        for folder, size in densities.items():
            folder_path = os.path.join(target, folder)
            os.makedirs(folder_path, exist_ok=True)
            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            out_file = os.path.join(folder_path, "ic_launcher.png")
            resized.save(out_file, "PNG")

        for folder, size in fg_densities.items():
            folder_path = os.path.join(target, folder)
            os.makedirs(folder_path, exist_ok=True)
            fg = Image.new("RGBA", (size, size), (0, 0, 0, 0))
            inner_size = int(size * 0.72)
            inner_icon = img.resize((inner_size, inner_size), Image.Resampling.LANCZOS)
            offset = (size - inner_size) // 2
            fg.paste(inner_icon, (offset, offset), mask=inner_icon)
            out_fg = os.path.join(folder_path, "ic_launcher_foreground.png")
            fg.save(out_fg, "PNG")

        # Create values/colors.xml
        values_dir = os.path.join(target, "values")
        os.makedirs(values_dir, exist_ok=True)
        colors_xml = os.path.join(values_dir, "colors.xml")
        with open(colors_xml, "w", encoding="utf-8") as f:
            f.write('<?xml version="1.0" encoding="utf-8"?>\n<resources>\n    <color name="ic_launcher_background">#0F3E6D</color>\n</resources>\n')

        # Create mipmap-anydpi-v26/ic_launcher.xml
        v26_dir = os.path.join(target, "mipmap-anydpi-v26")
        os.makedirs(v26_dir, exist_ok=True)
        launcher_xml = os.path.join(v26_dir, "ic_launcher.xml")
        with open(launcher_xml, "w", encoding="utf-8") as f:
            f.write('<?xml version="1.0" encoding="utf-8"?>\n<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n    <background android:drawable="@color/ic_launcher_background"/>\n    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n</adaptive-icon>\n')

    print("All launcher icons and adaptive icon XMLs generated successfully!")

if __name__ == "__main__":
    main()
