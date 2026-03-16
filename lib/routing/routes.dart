abstract final class Routes {
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';

  static const addProject = '/addProject';

  static const project = '/project';
  static String projectWithId(String id) => '$project/$id';

  static const task = '/task';
  static String taskWithId(String taskId) => '$task/$taskId';

  static const messages = '/messages';

  static const inbox = '/inbox';

  static const profile = '/profile';
}
