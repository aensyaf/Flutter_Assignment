class UnbordingContent {
  String image;
  String title;
  String description;

  UnbordingContent({required this.image, required this.title, required this.description});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Looking for online tutor?',
    image: 'assets/images/onboardpic1.png',
    description: "MyTutor provide a list of verified "
    "tutor from various background and  "
    "expertise! "
  ),
  UnbordingContent(
    title: 'One-to-one session',
    image: 'assets/images/onboardpic2.png',
    description: "Communicate with your tutor via  "
    "video call for faster learning  "
    "progression. "
  ),
  UnbordingContent(
    title: 'Stay safe! Learn at home',
    image: 'assets/images/onboardpic3.png',
    description: "Learning at home is a better way to "
    "avoid the chances of getting  "
    "infected by COVID-19. "
  ),
];