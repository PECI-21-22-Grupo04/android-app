class User {
  final String profilepic;
  final String coverimg;
  final String fname;
  final String lname;
  final String email;
  final String about;
  final String location;

  const User({
    this.profilepic =
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
    this.coverimg = "https://www.challengetires.com/assets/img/placeholder.jpg",
    required this.fname,
    required this.lname,
    this.email = "",
    this.location = "",
    this.about = "",
  });
}
