class ApiConstants {
  ApiConstants._();

  static const String serverUrl = "https://operational-plan-management-system-for-sarc.tahamove.com";
  static const String imagesUrl = "$serverUrl/storage";
  static const String baseUrl = "$serverUrl/api/";

  //Auth & Structure
  static const String login = "login";
  static const String logout = "logout";
  static const String users = "users";
  static const String departments = "departments";
  static const String units = "units";
  static const String outcomes = "outcomes";
  static const String outputs = "outputs";
  static const String indicators = "indicators";
  static const String activities = "activities";
  static const String roles = "roles";
  static const String userRole = 'user_roles';

  //Budget
  static const String reliefAssistance = 'relief_assistance_item';
  static const String runningCost = 'running_costs';
  static const String fieldVisits = 'field_visits';
  static const String equipments = 'equipments';
  static const String salaries = 'salaries';
  static const String trainingDescriptions = 'training_descriptions';
  static const String trainingSubDescriptions = 'training_sub_descriptions';
  static const String trainings = 'trainings';
  static const String trainingCosts = 'training_costs';
}