class APIPath {
  static String article(String uid, String articleId) =>
      '/users/$uid/repository/$articleId';
  static String repo(String uid) => 'users/$uid/repository';
}
