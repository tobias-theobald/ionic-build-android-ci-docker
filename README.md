# ionic-build-android-ci-docker

This image provides all tools required to automatically build and Android app out of your ionic (and possibly also cordova) project.

It is primarily meant to be run in a CI environment, such as Gitlab CI, but can certainly also be used to run the compilation process on any machine capable of running docker without having to go through the process of setting everything up.

Here is a sample .gitlab-ci.yml file for setting up the project and compiling it:

```yaml
...
```

It is important to manage your keystores correctly. For debugging, the android build tools will automatically fall back to `~/.android/debug.keystore`, which should not be password protected. Release keystores should be injected either via the repository or in a different way.

Finally, you can get your compiled file out of your container. The image includes `sftp`, `scp`, `rsync` and `s3cmd`, if you want to see more added, do not hesitate to send a pull request.
