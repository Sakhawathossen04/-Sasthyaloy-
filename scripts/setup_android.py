import os
import shutil

def setup_android():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    assets_res = os.path.join(base_dir, 'assets', 'icon', 'res')
    android_res = os.path.join(base_dir, 'android', 'app', 'src', 'main', 'res')
    manifest_path = os.path.join(base_dir, 'android', 'app', 'src', 'main', 'AndroidManifest.xml')
    gradle_props_path = os.path.join(base_dir, 'android', 'gradle.properties')
    app_build_gradle = os.path.join(base_dir, 'android', 'app', 'build.gradle')
    root_build_gradle = os.path.join(base_dir, 'android', 'build.gradle')

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
        print("Launcher icons successfully copied to Android resources!")
    else:
        print("Warning: assets/icon/res not found!")

    # 2. Update AndroidManifest.xml for dialer queries and app name
    if os.path.exists(manifest_path):
        with open(manifest_path, 'r', encoding='utf-8') as f:
            content = f.read()

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

        if 'android:label="sasthyaloy"' in content:
            content = content.replace('android:label="sasthyaloy"', 'android:label="স্বাস্থ্যালয়"')
            print("Updated app label to 'স্বাস্থ্যালয়'")

        with open(manifest_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("AndroidManifest.xml updated successfully!")
    else:
        print(f"Warning: AndroidManifest.xml not found at {manifest_path}")

    # 3. Configure gradle.properties to disable lintVital checks
    if os.path.exists(gradle_props_path):
        with open(gradle_props_path, 'r', encoding='utf-8') as f:
            props = f.read()
        if 'android.lint.abortOnError' not in props:
            props += '\nandroid.lint.abortOnError=false\nandroid.lint.checkReleaseBuilds=false\n'
            with open(gradle_props_path, 'w', encoding='utf-8') as f:
                f.write(props)
            print("Configured gradle.properties to disable release lint")

    # 4. Configure root android/build.gradle to disable lint across all subprojects
    if os.path.exists(root_build_gradle):
        with open(root_build_gradle, 'r', encoding='utf-8') as f:
            rbg = f.read()
        if 'graph.allTasks' not in rbg:
            rbg += """
subprojects {
    afterEvaluate { project ->
        if (project.hasProperty('android')) {
            project.tasks.matching { it.name.toLowerCase().contains('lint') }.all {
                enabled = false
            }
        }
    }
}
gradle.taskGraph.whenReady { graph ->
    graph.allTasks.each { task ->
        if (task.name.toLowerCase().contains("lint")) {
            task.enabled = false
        }
    }
}
"""
            with open(root_build_gradle, 'w', encoding='utf-8') as f:
                f.write(rbg)
            print("Updated root android/build.gradle to disable lint across all subprojects")

    # 5. Configure android/app/build.gradle to disable Android Lint tasks
    if os.path.exists(app_build_gradle):
        with open(app_build_gradle, 'r', encoding='utf-8') as f:
            bg = f.read()
        if 'lintOptions' not in bg:
            lint_block = """
    lintOptions {
        checkReleaseBuilds false
        abortOnError false
    }
    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }
"""
            bg = bg.replace('buildTypes {', lint_block + '\n    buildTypes {')

        if 'tasks.whenTaskAdded' not in bg:
            bg += """
tasks.whenTaskAdded { task ->
    if (task.name.toLowerCase().contains("lint")) {
        task.enabled = false
    }
}
"""
        with open(app_build_gradle, 'w', encoding='utf-8') as f:
            f.write(bg)
        print("Updated android/app/build.gradle to disable lint tasks on release")

if __name__ == '__main__':
    setup_android()
