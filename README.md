# ionic-build-android-ci-docker

## Attention! This project is no longer maintained. Feel free to fork it and make necessary modifications for your project.

This image provides all tools required to automatically build and Android app out of your ionic (and possibly also cordova) project.

It is primarily meant to be run in a CI environment, such as Gitlab CI, but can certainly also be used to run the compilation process on any machine capable of running docker without having to go through the process of setting everything up.

## CI Configuration

Here is a sample .gitlab-ci.yml file for setting up the project and compiling it:

```yaml
image: tobitheo/ionic-build-android-ci-docker:latest

compile_android:
  stage: build
  script:
    - cp debug.keystore ~/.android/debug.keystore
    - npm install
    - bower install --allow-root
    - ionic config build
    - ionic state restore
    - ionic build android
```

It is important to manage your keystores correctly. For signing debug releases, the android build tools will automatically fall back to `~/.android/debug.keystore`, which should not be password protected.

## .gitignore

This example assumes, that your `.gitignore` looks approximately like this: 

```
node_modules/
platforms/
plugins/
www/lib/
```

That will avoid checking in generated files or dependencies, that will be restored using the aforementioned commands during build.

## Getting the files out

Finally, you can get your compiled file out of your container. The image includes `sftp`, `scp`, `rsync`, `sendemail` with `ssmtp` and `s3cmd`, if you want to see more added, do not hesitate to send a pull request.

To send the apk in a mail, use sendemail to send the compiled APK as an attachment to yourself (using GMail):

```
    - sendemail -f $GMAIL_USER@gmail.com -t $MAIL_RCPT -s smtp.gmail.com:587 -xu $GMAIL_USER -xp $GMAIL_PASS -u "New CI build $CI_BUILD_ID" -m "Hi, \nthis is your Gitlab CI building $CI_BUILD_REPO, branch/tag $CI_BUILD_REF_NAME, commit $CI_BUILD_REF. \nThe generated APK file is attached. \nRegards, \n$CI_SERVER_NAME" -a platforms/android/build/outputs/apk/android-debug.apk
```

Note that `GMAIL_USER`, `GMAIL_PASS` and `MAIL_RCPT` are environment variables that have to be configured in the project settings -> Variables and the `CI_*` variables are set by the CI system and for Gitlab CI are documented [here](http://doc.gitlab.com/ce/ci/variables/README.html). The documentation for `sendemail` is [here](https://github.com/mogaal/sendemail).
