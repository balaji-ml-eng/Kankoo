import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    for context in connectionOptions.urlContexts { ShortcutURLForwarder.capture(context.url) }
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    for context in URLContexts where ShortcutURLForwarder.accepts(context.url) { ShortcutURLForwarder.capture(context.url) }
    let other = Set(URLContexts.filter { !ShortcutURLForwarder.accepts($0.url) })
    if !other.isEmpty { super.scene(scene, openURLContexts: other) }
  }
}
