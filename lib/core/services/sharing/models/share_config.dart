class ShareConfig {
  const ShareConfig({
    this.department,
    this.imageName = 'shared_content',
  });
  final String? department;
  final String imageName;

  static ShareConfig? from({
    String? department,
    String imageName = 'shared_content',
  }) {
    if (department == null && imageName == 'shared_content') {
      return null;
    }
    return ShareConfig(
      department: department,
      imageName: imageName,
    );
  }
}
