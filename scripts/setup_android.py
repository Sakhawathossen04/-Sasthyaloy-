import os
import shutil
import xml.etree.ElementTree as ET

def setup_android():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    assets_res = os.path.join(base_dir, 'assets', 'icon', 'res')
    android_res = os.path.join(base_dir, 'android', 'app', 'src', 'main', 'res')
    manifest_path = os.path.join(base_dir, 'android', 'app', 'src', 'main', 'AndroidManifest.xml')

    print(f"Base Directory: {base_dir}")
    print(f"Assets Res: {assets_res}")
    print(f"Android Res: {android_res}")

    # 1. Copy custom launcher icons from assets/icon/res to android/app/src/main/res
    if os.path.exists(assets_res):
        for root, dirs, files in os.walk(assets_res):
            rel_path = os.path.relpath(root, assets_res)
            target_dir = os.path.join(android_res, rel_path)
            os.makedirs(target_dir, exist_ok=True)
            for f in files:
                src_file = os.path.join(root, f)
                dst_file = os.path.join(target_dir, f)
                shutil.copy2(src_file, dst_file)
                print(f"Copied {f} to {rel_path}/")
        print("Launcher icons successfully copied to Android resources!")
    else:
        print("Warning: assets/icon/res not found!")

    # 2. Update AndroidManifest.xml for dialer queries and app name
    if os.path.exists(manifest_path):
        with open(manifest_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Add queries block for phone dialer if not present
        if '<action android:name="android.intent.action.DIAL"' not in content:
            dialer_queries = """
    <queries>
        <intent>
            <action android:name="android.intent.action.DIAL" />
            <data android:scheme="tel" />
        </intent>
    </queries>
</manifest>"""
            content = content.replace('</manifest>', dialer_queries)
            print("Added phone dialer queries to AndroidManifest.xml")

        # Set Bengali/English app label if default flutter label
        if 'android:label="sasthyaloy"' in content:
            content = content.replace('android:label="sasthyaloy"', 'android:label="স্বাস্থ্যালয়"')
            print("Updated app label to 'স্বাস্থ্যালয়'")

        with open(manifest_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("AndroidManifest.xml updated successfully!")
    else:
        print(f"Warning: AndroidManifest.xml not found at {manifest_path}")

if __name__ == '__main__':
    setup_android()
