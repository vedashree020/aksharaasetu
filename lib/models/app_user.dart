enum UserRole {
  teacher,
  student,
  admin,
}

class AppUser {
  final String name;
  final UserRole role;

  const AppUser({
    required this.name,
    required this.role,
  });

  String get roleName {
    switch (role) {
      case UserRole.teacher:
        return 'Teacher';

      case UserRole.student:
        return 'Student';

      case UserRole.admin:
        return 'Admin';
    }
  }

  String get roleNameHindi {
    switch (role) {
      case UserRole.teacher:
        return 'शिक्षक';

      case UserRole.student:
        return 'विद्यार्थी';

      case UserRole.admin:
        return 'व्यवस्थापक';
    }
  }

  String get roleDescription {
    switch (role) {
      case UserRole.teacher:
        return 'Teach, translate and create learning content';

      case UserRole.student:
        return 'Learn, listen, practice and take quizzes';

      case UserRole.admin:
        return 'Manage languages, lessons and resources';
    }
  }

  String get roleDescriptionHindi {
    switch (role) {
      case UserRole.teacher:
        return 'पढ़ाएं, अनुवाद करें और शिक्षण सामग्री बनाएं';

      case UserRole.student:
        return 'सीखें, सुनें, अभ्यास करें और क्विज़ दें';

      case UserRole.admin:
        return 'भाषाओं, पाठों और संसाधनों का प्रबंधन करें';
    }
  }

  String get roleIconName {
    switch (role) {
      case UserRole.teacher:
        return 'teacher';

      case UserRole.student:
        return 'student';

      case UserRole.admin:
        return 'admin';
    }
  }
}