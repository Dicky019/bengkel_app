import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/resources/pages/login_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller.dart';

class HomeController extends Controller {
  onTapDocumentation() async {
    await launchUrl(Uri.parse("https://nylo.dev/docs"));
  }

  onTapGithub() async {
    await launchUrl(Uri.parse("https://github.com/nylo-core/nylo"));
  }

  onTapChangeLog() async {
    await launchUrl(Uri.parse(
      "https://github.com/nylo-core/nylo/releases",
    ));
  }

  onTapYouTube() async {
    await launchUrl(Uri.parse("https://m.youtube.com/@nylo_dev"));
  }

  User? get getUser => Auth.user<User>();

  showAbout() async {
    await Auth.remove();
    routeTo(LoginPage.path);
  }
}
