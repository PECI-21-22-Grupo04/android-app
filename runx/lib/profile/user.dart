class User {
  String profilepic;
  String coverimg;
  String fname;
  String lname;
  String email;
  String about;
  String location;

  User({
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
