/// Everyday Gem — Localization
/// Default language: Korean (ko)
/// Supported: ko, en

class AppLocalizations {
  final String locale;

  AppLocalizations(this.locale);

  String get(String key) {
    final map = locale == 'en' ? _en : _ko;
    return map[key] ?? _ko[key] ?? key;
  }

  // ─── Common ───
  static const kCancel = 'cancel';
  static const kSave = 'save';
  static const kDelete = 'delete';
  static const kAdd = 'add';
  static const kNext = 'next';
  static const kSkip = 'skip';
  static const kDone = 'done';
  static const kClose = 'close';
  static const kConfirm = 'confirm';
  static const kToday = 'today';
  static const kThisWeek = 'thisWeek';
  static const kThisMonth = 'thisMonth';
  static const kSummary = 'summary';
  static const kDetails = 'details';
  static const kGetStarted = 'getStarted';
  static const kContinue = 'continueBtn';
  static const kAccept = 'accept';
  static const kDecline = 'decline';
  static const kRedeem = 'redeem';
  static const kSendRequest = 'sendRequest';

  // ─── Navigation ───
  static const kNavHome = 'navHome';
  static const kNavExplore = 'navExplore';
  static const kNavActivity = 'navActivity';
  static const kNavProfile = 'navProfile';

  // ─── Onboarding ───
  static const kOnboarding1Title = 'onboarding1Title';
  static const kOnboarding1Subtitle = 'onboarding1Subtitle';
  static const kOnboarding2Title = 'onboarding2Title';
  static const kOnboarding2Subtitle = 'onboarding2Subtitle';
  static const kOnboarding3Title = 'onboarding3Title';
  static const kOnboarding3Subtitle = 'onboarding3Subtitle';

  // ─── Create Account ───
  static const kCreateAccount = 'createAccount';
  static const kName = 'name';
  static const kSurname = 'surname';
  static const kBirthdate = 'birthdate';
  static const kEnterName = 'enterName';
  static const kEnterSurname = 'enterSurname';
  static const kBirthdateHint = 'birthdateHint';
  static const kChooseGender = 'chooseGender';
  static const kMale = 'male';
  static const kFemale = 'female';
  static const kChooseFirstHabits = 'chooseFirstHabits';
  static const kAddMoreLater = 'addMoreLater';
  static const kPleaseEnterName = 'pleaseEnterName';

  // ─── Habit names (for initial selection) ───
  static const kHabitDrinkWater = 'habitDrinkWater';
  static const kHabitRun = 'habitRun';
  static const kHabitReadBooks = 'habitReadBooks';
  static const kHabitMeditate = 'habitMeditate';
  static const kHabitStudy = 'habitStudy';
  static const kHabitJournal = 'habitJournal';
  static const kHabitPlants = 'habitPlants';
  static const kHabitSocialize = 'habitSocialize';

  // ─── Home Screen ───
  static const kHiUser = 'hiUser';
  static const kLetsMakeHabits = 'letsMakeHabits';
  static const kAddFirstHabit = 'addFirstHabit';
  static const kHabitsCompleted = 'habitsCompleted';
  static const kDailyGoalsAlmostDone = 'dailyGoalsAlmostDone';
  static const kHabits = 'habits';
  static const kViewAll = 'viewAll';
  static const kNoHabitsYet = 'noHabitsYet';
  static const kTapToAddHabit = 'tapToAddHabit';
  static const kAddHabit = 'addHabit';
  static const kDeleteHabit = 'deleteHabit';
  static const kDeleteHabitConfirm = 'deleteHabitConfirm';

  // ─── Add/Edit Habit ───
  static const kCreateCustomHabit = 'createCustomHabit';
  static const kEditHabit = 'editHabit';
  static const kHabitName = 'habitName';
  static const kChooseIcon = 'chooseIcon';
  static const kChooseColor = 'chooseColor';
  static const kRepeatOn = 'repeatOn';
  static const kAddReminder = 'addReminder';
  static const kSetReminderTime = 'setReminderTime';
  static const kSaveChanges = 'saveChanges';
  static const kPleaseEnterHabitName = 'pleaseEnterHabitName';

  // ─── Explore Screen ───
  static const kExplore = 'explore';
  static const kSearchHabits = 'searchHabits';
  static const kAll = 'all';
  static const kHealth = 'health';
  static const kFitness = 'fitness';
  static const kMind = 'mind';
  static const kLifestyle = 'lifestyle';
  static const kSuggestedForYou = 'suggestedForYou';
  static const kQuickAdd = 'quickAdd';
  static const kChallenges = 'challenges';
  static const kTipsMotivation = 'tipsMotivation';
  static const kNoMatchingHabits = 'noMatchingHabits';
  static const kAllSuggestedAdded = 'allSuggestedAdded';
  static const kAdded = 'added';

  // Suggested habits
  static const kSugDrinkWater = 'sugDrinkWater';
  static const kSugWalk = 'sugWalk';
  static const kSugSwim = 'sugSwim';
  static const kSugRead = 'sugRead';
  static const kSugMeditate = 'sugMeditate';
  static const kSugExercise = 'sugExercise';
  static const kSugSleepEarly = 'sugSleepEarly';
  static const kSugJournal = 'sugJournal';
  static const kSugEatFruits = 'sugEatFruits';
  static const kSugCleanUp = 'sugCleanUp';
  static const kSugPracticeMusic = 'sugPracticeMusic';
  static const kSugGoOutside = 'sugGoOutside';

  // Suggested habit details
  static const kSugDetail8Glasses = 'sugDetail8Glasses';
  static const kSugDetail10kSteps = 'sugDetail10kSteps';
  static const kSugDetail30min = 'sugDetail30min';
  static const kSugDetail20min = 'sugDetail20min';
  static const kSugDetail10min = 'sugDetail10min';
  static const kSugDetailBefore11 = 'sugDetailBefore11';
  static const kSugDetail5min = 'sugDetail5min';
  static const kSugDetail2Servings = 'sugDetail2Servings';
  static const kSugDetail15min = 'sugDetail15min';

  // Challenges
  static const kChallenge7Day = 'challenge7Day';
  static const kChallenge7DaySub = 'challenge7DaySub';
  static const kChallengeEarlyBird = 'challengeEarlyBird';
  static const kChallengeEarlyBirdSub = 'challengeEarlyBirdSub';
  static const kChallengePerfectWeek = 'challengePerfectWeek';
  static const kChallengePerfectWeekSub = 'challengePerfectWeekSub';

  // Tips
  static const kTipStartSmall = 'tipStartSmall';
  static const kTipStartSmallBody = 'tipStartSmallBody';
  static const kTipStackHabits = 'tipStackHabits';
  static const kTipStackHabitsBody = 'tipStackHabitsBody';

  // ─── Activity Screen ───
  static const kActivity = 'activity';
  static const kDaily = 'daily';
  static const kWeekly = 'weekly';
  static const kMonthly = 'monthly';
  static const kCompleted = 'completed';
  static const kTotal = 'total';
  static const kRate = 'rate';
  static const kActiveHabits = 'activeHabits';
  static const kBestStreak = 'bestStreak';
  static const kHabitDetails = 'habitDetails';
  static const kThisWeekShort = 'thisWeekShort';
  static const kDayStreak = 'dayStreak';

  // ─── Profile Screen ───
  static const kYourProfile = 'yourProfile';
  static const kFriends = 'friends';
  static const kDaysActive = 'daysActive';
  static const kActivityTab = 'activityTab';
  static const kAchievements = 'achievements';
  static const kRecentActivity = 'recentActivity';
  static const kCompletedAction = 'completedAction';
  static const kOngoing = 'ongoing';
  static const kCompleteHabitToSee = 'completeHabitToSee';

  // Achievements
  static const kAchFirstStep = 'achFirstStep';
  static const kAchFirstStepSub = 'achFirstStepSub';
  static const kAchGettingStarted = 'achGettingStarted';
  static const kAchGettingStartedSub = 'achGettingStartedSub';
  static const kAchConsistent = 'achConsistent';
  static const kAchConsistentSub = 'achConsistentSub';
  static const kAchOnFire = 'achOnFire';
  static const kAchOnFireSub = 'achOnFireSub';
  static const kAchGemCollector = 'achGemCollector';
  static const kAchGemCollectorSub = 'achGemCollectorSub';
  static const kAchUnstoppable = 'achUnstoppable';
  static const kAchUnstoppableSub = 'achUnstoppableSub';

  // ─── Settings Screen ───
  static const kSettings = 'settings';
  static const kGeneral = 'general';
  static const kEditProfile = 'editProfile';
  static const kDarkMode = 'darkMode';
  static const kNotifications = 'notifications';
  static const kLocationReminders = 'locationReminders';
  static const kSounds = 'sounds';
  static const kLanguage = 'language';
  static const kAboutUs = 'aboutUs';
  static const kRateApp = 'rateApp';
  static const kShareWithFriends = 'shareWithFriends';
  static const kSupport = 'support';
  static const kEditName = 'editName';
  static const kEnterYourName = 'enterYourName';

  // ─── Rewards Screen ───
  static const kRewards = 'rewards';
  static const kGems = 'gems';
  static const kGemsToNextLevel = 'gemsToNextLevel';
  static const kAvailableRewards = 'availableRewards';
  static const kNoRewardsYet = 'noRewardsYet';
  static const kRecentHistory = 'recentHistory';
  static const kHabitCompleted = 'habitCompleted';
  static const kStreakBonus = 'streakBonus';
  static const kRewardRedeemed = 'rewardRedeemed';
  static const kAddReward = 'addReward';
  static const kRewardName = 'rewardName';
  static const kCostInGems = 'costInGems';
  static const kRedeemed = 'redeemed';

  // ─── Friends Screen ───
  static const kMyInviteCode = 'myInviteCode';
  static const kCodeCopied = 'codeCopied';
  static const kShareCodeMessage = 'shareCodeMessage';
  static const kPendingRequests = 'pendingRequests';
  static const kFriendRequest = 'friendRequest';
  static const kNoFriendsYet = 'noFriendsYet';
  static const kShareCodeToConnect = 'shareCodeToConnect';
  static const kAddFriend = 'addFriend';
  static const kEnterInviteCode = 'enterInviteCode';
  static const kRelationship = 'relationship';
  static const kFriend = 'friend';
  static const kParentChild = 'parentChild';
  static const kFriendRequestSent = 'friendRequestSent';
  static const kCouldNotFindUser = 'couldNotFindUser';

  // ─── Location Screen ───
  static const kNoLocationReminders = 'noLocationReminders';
  static const kTapToAddLocation = 'tapToAddLocation';
  static const kAddLocationReminder = 'addLocationReminder';
  static const kLocationName = 'locationName';
  static const kLocationNameHint = 'locationNameHint';
  static const kTriggerWhen = 'triggerWhen';
  static const kArrive = 'arrive';
  static const kLeave = 'leave';
  static const kRadius = 'radius';
  static const kUsesCurrentLocation = 'usesCurrentLocation';
  static const kCouldNotGetLocation = 'couldNotGetLocation';
  static const kOnArrive = 'onArrive';
  static const kOnLeave = 'onLeave';

  // ─── Stats Screens ───
  static const kDetailedStats = 'detailedStats';
  static const kOverview = 'overview';
  static const kMonthlyTrend = 'monthlyTrend';
  static const kTotalDays = 'totalDays';
  static const kCurrentStreak = 'currentStreak';
  static const kByDayOfWeek = 'byDayOfWeek';
  static const kMonthlyRate = 'monthlyRate';

  // ─── Level names ───
  static const kLevelSeedling = 'levelSeedling';
  static const kLevelSprout = 'levelSprout';
  static const kLevelTree = 'levelTree';
  static const kLevelGem = 'levelGem';
  static const kLevelDiamond = 'levelDiamond';

  // ─── Day names ───
  static const kMon = 'mon';
  static const kTue = 'tue';
  static const kWed = 'wed';
  static const kThu = 'thu';
  static const kFri = 'fri';
  static const kSat = 'sat';
  static const kSun = 'sun';

  // ────────────────────────────────────────────
  //  Korean (default)
  // ────────────────────────────────────────────
  static const _ko = <String, String>{
    // Common
    kCancel: '취소',
    kSave: '저장',
    kDelete: '삭제',
    kAdd: '추가',
    kNext: '다음',
    kSkip: '건너뛰기',
    kDone: '완료',
    kClose: '닫기',
    kConfirm: '확인',
    kToday: '오늘',
    kThisWeek: '이번 주',
    kThisMonth: '이번 달',
    kSummary: '요약',
    kDetails: '상세',
    kGetStarted: '시작하기',
    kContinue: '계속',
    kAccept: '수락',
    kDecline: '거절',
    kRedeem: '교환',
    kSendRequest: '요청 보내기',

    // Navigation
    kNavHome: '홈',
    kNavExplore: '탐색',
    kNavActivity: '활동',
    kNavProfile: '프로필',

    // Onboarding
    kOnboarding1Title: '좋은 습관\n만들기',
    kOnboarding1Subtitle: '새로운 건강한 습관을 천천히 추가하고 꾸준히 실천하여 삶을 변화시키세요.',
    kOnboarding2Title: '진행 상황\n추적하기',
    kOnboarding2Subtitle: '매일 목표에 한 걸음 더 가까워집니다. 포기하지 마세요!',
    kOnboarding3Title: '함께\n성장하기',
    kOnboarding3Subtitle: '친구들과 함께 이야기하고 챌린지를 완수해보세요.',

    // Create Account
    kCreateAccount: '계정 만들기',
    kName: '이름',
    kSurname: '성',
    kBirthdate: '생년월일',
    kEnterName: '이름을 입력하세요',
    kEnterSurname: '성을 입력하세요',
    kBirthdateHint: 'YYYY/MM/DD',
    kChooseGender: '성별을 선택하세요',
    kMale: '남성',
    kFemale: '여성',
    kChooseFirstHabits: '첫 번째 습관을 선택하세요',
    kAddMoreLater: '나중에 더 추가할 수 있어요',
    kPleaseEnterName: '이름을 입력해주세요',

    // Habit names
    kHabitDrinkWater: '물 마시기',
    kHabitRun: '달리기',
    kHabitReadBooks: '독서',
    kHabitMeditate: '명상',
    kHabitStudy: '공부',
    kHabitJournal: '일기 쓰기',
    kHabitPlants: '식물 가꾸기',
    kHabitSocialize: '소통하기',

    // Home
    kHiUser: '안녕하세요, {name} 님 👋',
    kLetsMakeHabits: '오늘도 좋은 습관을 함께 만들어요!',
    kAddFirstHabit: '첫 번째 습관을 추가하세요!',
    kHabitsCompleted: '{completed}/{total}개 습관 완료',
    kDailyGoalsAlmostDone: '일일 목표를 거의 달성했어요! 🔥',
    kHabits: '습관',
    kViewAll: '전체 보기',
    kNoHabitsYet: '아직 습관이 없어요',
    kTapToAddHabit: '+를 눌러 첫 번째 습관을 추가하세요',
    kAddHabit: '습관 추가',
    kDeleteHabit: '습관 삭제',
    kDeleteHabitConfirm: '"{name}"을(를) 삭제하시겠습니까?',

    // Add/Edit Habit
    kCreateCustomHabit: '나만의 습관 만들기',
    kEditHabit: '습관 수정',
    kHabitName: '습관 이름',
    kChooseIcon: '아이콘 선택',
    kChooseColor: '색상 선택',
    kRepeatOn: '반복 요일',
    kAddReminder: '알림 추가',
    kSetReminderTime: '알림 시간 설정',
    kSaveChanges: '변경사항 저장',
    kPleaseEnterHabitName: '습관 이름을 입력해주세요',

    // Explore
    kExplore: '탐색',
    kSearchHabits: '습관 검색...',
    kAll: '전체',
    kHealth: '건강',
    kFitness: '운동',
    kMind: '마음',
    kLifestyle: '생활',
    kSuggestedForYou: '추천 습관',
    kQuickAdd: '빠른 추가',
    kChallenges: '챌린지',
    kTipsMotivation: '팁 & 동기부여',
    kNoMatchingHabits: '일치하는 습관이 없습니다',
    kAllSuggestedAdded: '추천 습관을 모두 추가했어요!',
    kAdded: '추가됨!',

    // Suggested habits
    kSugDrinkWater: '물 마시기',
    kSugWalk: '걷기',
    kSugSwim: '수영',
    kSugRead: '독서',
    kSugMeditate: '명상',
    kSugExercise: '운동',
    kSugSleepEarly: '일찍 자기',
    kSugJournal: '일기',
    kSugEatFruits: '과일 먹기',
    kSugCleanUp: '정리정돈',
    kSugPracticeMusic: '악기 연습',
    kSugGoOutside: '바깥 활동',

    // Suggested details
    kSugDetail8Glasses: '8잔',
    kSugDetail10kSteps: '10,000걸음',
    kSugDetail30min: '30분',
    kSugDetail20min: '20분',
    kSugDetail10min: '10분',
    kSugDetailBefore11: '밤 11시 전',
    kSugDetail5min: '5분',
    kSugDetail2Servings: '2인분',
    kSugDetail15min: '15분',

    // Challenges
    kChallenge7Day: '7일 연속 도전',
    kChallenge7DaySub: '7일 연속으로 습관을 완료하세요',
    kChallengeEarlyBird: '얼리버드',
    kChallengeEarlyBirdSub: '정오 전에 모든 습관 완료하기',
    kChallengePerfectWeek: '완벽한 한 주',
    kChallengePerfectWeekSub: '이번 주 매일 모든 습관 완료하기',

    // Tips
    kTipStartSmall: '작게 시작하고 크게 성장하세요',
    kTipStartSmallBody: '하루 2분부터 시작하세요. 꾸준함이 강도를 이깁니다.',
    kTipStackHabits: '습관을 쌓아보세요',
    kTipStackHabitsBody: '기존 습관에 새 습관을 연결하세요. "양치질 후 명상하기"처럼요.',

    // Activity
    kActivity: '활동',
    kDaily: '일간',
    kWeekly: '주간',
    kMonthly: '월간',
    kCompleted: '완료',
    kTotal: '전체',
    kRate: '달성률',
    kActiveHabits: '활성 습관',
    kBestStreak: '최고 연속',
    kHabitDetails: '습관 상세',
    kThisWeekShort: '이번 주',
    kDayStreak: '일 연속',

    // Profile
    kYourProfile: '내 프로필',
    kFriends: '친구',
    kDaysActive: '활동 일수',
    kActivityTab: '활동',
    kAchievements: '업적',
    kRecentActivity: '최근 활동',
    kCompletedAction: '완료',
    kOngoing: '진행 중',
    kCompleteHabitToSee: '습관을 완료하면 활동이 표시됩니다',

    // Achievements
    kAchFirstStep: '첫걸음!',
    kAchFirstStepSub: '첫 번째 습관을 완료하세요',
    kAchGettingStarted: '시작이 반!',
    kAchGettingStartedSub: '습관 10회 완료',
    kAchConsistent: '꾸준함',
    kAchConsistentSub: '3일 연속 달성',
    kAchOnFire: '불타오르는 열정',
    kAchOnFireSub: '7일 연속 달성',
    kAchGemCollector: '보석 수집가',
    kAchGemCollectorSub: '습관 50회 완료',
    kAchUnstoppable: '멈출 수 없는 나',
    kAchUnstoppableSub: '30일 연속 달성',

    // Settings
    kSettings: '설정',
    kGeneral: '일반',
    kEditProfile: '프로필 수정',
    kDarkMode: '다크 모드',
    kNotifications: '알림',
    kLocationReminders: '위치 알림',
    kSounds: '소리',
    kLanguage: '언어',
    kAboutUs: '앱 정보',
    kRateApp: 'Everyday Gem 평가하기',
    kShareWithFriends: '친구에게 공유하기',
    kSupport: '지원',
    kEditName: '이름 수정',
    kEnterYourName: '이름을 입력하세요',

    // Rewards
    kRewards: '보상',
    kGems: '보석',
    kGemsToNextLevel: '다음 레벨까지 {count}개 보석',
    kAvailableRewards: '사용 가능한 보상',
    kNoRewardsYet: '아직 보상이 없어요. +를 눌러 추가하세요!',
    kRecentHistory: '최근 기록',
    kHabitCompleted: '습관 완료',
    kStreakBonus: '연속 보너스',
    kRewardRedeemed: '보상 교환',
    kAddReward: '보상 추가',
    kRewardName: '보상 이름 (예: 아이스크림)',
    kCostInGems: '비용 (보석, 예: 50)',
    kRedeemed: '교환 완료!',

    // Friends
    kMyInviteCode: '나의 초대 코드',
    kCodeCopied: '코드가 복사되었습니다!',
    kShareCodeMessage: '이 코드를 가족, 친구에게 공유하세요',
    kPendingRequests: '대기 중인 요청',
    kFriendRequest: '친구 요청',
    kNoFriendsYet: '아직 친구가 없어요',
    kShareCodeToConnect: '초대 코드를 공유해서 연결하세요!',
    kAddFriend: '친구 추가',
    kEnterInviteCode: '초대 코드 입력',
    kRelationship: '관계:',
    kFriend: '친구',
    kParentChild: '부모-자녀',
    kFriendRequestSent: '친구 요청을 보냈습니다!',
    kCouldNotFindUser: '해당 코드의 사용자를 찾을 수 없습니다',

    // Location
    kNoLocationReminders: '위치 알림이 없습니다',
    kTapToAddLocation: '+를 눌러 위치 기반 알림을 추가하세요',
    kAddLocationReminder: '위치 알림 추가',
    kLocationName: '위치 이름',
    kLocationNameHint: '위치 이름 (예: 헬스장)',
    kTriggerWhen: '알림 조건:',
    kArrive: '도착 시',
    kLeave: '출발 시',
    kRadius: '반경: {radius}m',
    kUsesCurrentLocation: '저장 시 현재 위치를 사용합니다.',
    kCouldNotGetLocation: '위치를 가져올 수 없습니다. 권한을 확인하세요.',
    kOnArrive: '도착 시',
    kOnLeave: '출발 시',

    // Stats
    kDetailedStats: '상세 통계',
    kOverview: '전체 현황',
    kMonthlyTrend: '월간 추세',
    kTotalDays: '총 일수',
    kCurrentStreak: '현재 연속',
    kByDayOfWeek: '요일별 현황',
    kMonthlyRate: '월별 달성률',

    // Level names
    kLevelSeedling: '🌱 새싹',
    kLevelSprout: '🌿 싹',
    kLevelTree: '🌳 나무',
    kLevelGem: '💎 보석',
    kLevelDiamond: '👑 다이아몬드',

    // Day names
    kMon: '월',
    kTue: '화',
    kWed: '수',
    kThu: '목',
    kFri: '금',
    kSat: '토',
    kSun: '일',
  };

  // ────────────────────────────────────────────
  //  English
  // ────────────────────────────────────────────
  static const _en = <String, String>{
    // Common
    kCancel: 'Cancel',
    kSave: 'Save',
    kDelete: 'Delete',
    kAdd: 'Add',
    kNext: 'Next',
    kSkip: 'Skip',
    kDone: 'Done',
    kClose: 'Close',
    kConfirm: 'Confirm',
    kToday: 'Today',
    kThisWeek: 'This Week',
    kThisMonth: 'This Month',
    kSummary: 'Summary',
    kDetails: 'Details',
    kGetStarted: 'Get Started',
    kContinue: 'Continue',
    kAccept: 'Accept',
    kDecline: 'Decline',
    kRedeem: 'Redeem',
    kSendRequest: 'Send Request',

    // Navigation
    kNavHome: 'Home',
    kNavExplore: 'Explore',
    kNavActivity: 'Activity',
    kNavProfile: 'Profile',

    // Onboarding
    kOnboarding1Title: 'Create\nGood Habits',
    kOnboarding1Subtitle: 'Change your life by slowly adding new healthy habits and sticking to them.',
    kOnboarding2Title: 'Track\nYour Progress',
    kOnboarding2Subtitle: 'Everyday you become one step closer to your goal. Don\'t give up!',
    kOnboarding3Title: 'Stay Together\nand Strong',
    kOnboarding3Subtitle: 'Find friends to discuss common topics. Complete challenges together.',

    // Create Account
    kCreateAccount: 'Create Account',
    kName: 'NAME',
    kSurname: 'SURNAME',
    kBirthdate: 'BIRTHDATE',
    kEnterName: 'Enter your name',
    kEnterSurname: 'Enter your surname',
    kBirthdateHint: 'mm/dd/yyyy',
    kChooseGender: 'Choose your gender',
    kMale: 'Male',
    kFemale: 'Female',
    kChooseFirstHabits: 'Choose your first habits',
    kAddMoreLater: 'You may add more habits later',
    kPleaseEnterName: 'Please enter your name',

    // Habit names
    kHabitDrinkWater: 'Drink water',
    kHabitRun: 'Run',
    kHabitReadBooks: 'Read books',
    kHabitMeditate: 'Meditate',
    kHabitStudy: 'Study',
    kHabitJournal: 'Journal',
    kHabitPlants: 'Plants',
    kHabitSocialize: 'Socialize',

    // Home
    kHiUser: 'Hi, {name} 👋',
    kLetsMakeHabits: "Let's make habits together!",
    kAddFirstHabit: 'Add your first habit!',
    kHabitsCompleted: '{completed}/{total} habits completed',
    kDailyGoalsAlmostDone: 'Your daily goals almost done! 🔥',
    kHabits: 'Habits',
    kViewAll: 'VIEW ALL',
    kNoHabitsYet: 'No habits yet',
    kTapToAddHabit: 'Tap + to add your first habit',
    kAddHabit: 'Add Habit',
    kDeleteHabit: 'Delete Habit',
    kDeleteHabitConfirm: 'Are you sure you want to delete "{name}"?',

    // Add/Edit Habit
    kCreateCustomHabit: 'Create Custom Habit',
    kEditHabit: 'Edit Habit',
    kHabitName: 'Habit name',
    kChooseIcon: 'CHOOSE AN ICON',
    kChooseColor: 'CHOOSE A COLOR',
    kRepeatOn: 'REPEAT ON',
    kAddReminder: 'ADD REMINDER',
    kSetReminderTime: 'Set reminder time',
    kSaveChanges: 'Save Changes',
    kPleaseEnterHabitName: 'Please enter a habit name',

    // Explore
    kExplore: 'Explore',
    kSearchHabits: 'Search habits...',
    kAll: 'All',
    kHealth: 'Health',
    kFitness: 'Fitness',
    kMind: 'Mind',
    kLifestyle: 'Lifestyle',
    kSuggestedForYou: 'Suggested for You',
    kQuickAdd: 'Quick Add',
    kChallenges: 'Challenges',
    kTipsMotivation: 'Tips & Motivation',
    kNoMatchingHabits: 'No matching habits found',
    kAllSuggestedAdded: 'You\'ve added all suggested habits!',
    kAdded: 'added!',

    // Suggested habits
    kSugDrinkWater: 'Drink Water',
    kSugWalk: 'Walk',
    kSugSwim: 'Swim',
    kSugRead: 'Read',
    kSugMeditate: 'Meditate',
    kSugExercise: 'Exercise',
    kSugSleepEarly: 'Sleep Early',
    kSugJournal: 'Journal',
    kSugEatFruits: 'Eat Fruits',
    kSugCleanUp: 'Clean Up',
    kSugPracticeMusic: 'Practice Music',
    kSugGoOutside: 'Go Outside',

    // Suggested details
    kSugDetail8Glasses: '8 glasses',
    kSugDetail10kSteps: '10,000 steps',
    kSugDetail30min: '30 min',
    kSugDetail20min: '20 min',
    kSugDetail10min: '10 min',
    kSugDetailBefore11: 'Before 11pm',
    kSugDetail5min: '5 min',
    kSugDetail2Servings: '2 servings',
    kSugDetail15min: '15 min',

    // Challenges
    kChallenge7Day: '7 Day Streak',
    kChallenge7DaySub: 'Complete any habit for 7 days straight',
    kChallengeEarlyBird: 'Early Bird',
    kChallengeEarlyBirdSub: 'Complete all habits before noon',
    kChallengePerfectWeek: 'Perfect Week',
    kChallengePerfectWeekSub: 'Complete all habits every day this week',

    // Tips
    kTipStartSmall: 'Start small, grow big',
    kTipStartSmallBody: 'Begin with just 2 minutes a day. Consistency beats intensity.',
    kTipStackHabits: 'Stack your habits',
    kTipStackHabitsBody: 'Attach a new habit to an existing one. "After I brush my teeth, I will meditate."',

    // Activity
    kActivity: 'Activity',
    kDaily: 'Daily',
    kWeekly: 'Weekly',
    kMonthly: 'Monthly',
    kCompleted: 'COMPLETED',
    kTotal: 'TOTAL',
    kRate: 'RATE',
    kActiveHabits: 'Active Habits',
    kBestStreak: 'Best Streak',
    kHabitDetails: 'Habit Details',
    kThisWeekShort: 'this week',
    kDayStreak: 'day streak',

    // Profile
    kYourProfile: 'Your Profile',
    kFriends: 'Friends',
    kDaysActive: 'Days Active',
    kActivityTab: 'Activity',
    kAchievements: 'Achievements',
    kRecentActivity: 'Recent Activity',
    kCompletedAction: 'completed',
    kOngoing: 'Ongoing',
    kCompleteHabitToSee: 'Complete a habit to see activity here',

    // Achievements
    kAchFirstStep: 'First Step!',
    kAchFirstStepSub: 'Complete your first habit',
    kAchGettingStarted: 'Getting Started',
    kAchGettingStartedSub: 'Complete 10 habits',
    kAchConsistent: 'Consistent',
    kAchConsistentSub: '3 day streak',
    kAchOnFire: 'On Fire',
    kAchOnFireSub: '7 day streak',
    kAchGemCollector: 'Gem Collector',
    kAchGemCollectorSub: 'Complete 50 habits',
    kAchUnstoppable: 'Unstoppable',
    kAchUnstoppableSub: '30 day streak',

    // Settings
    kSettings: 'Settings',
    kGeneral: 'GENERAL',
    kEditProfile: 'Edit Profile',
    kDarkMode: 'Dark Mode',
    kNotifications: 'Notifications',
    kLocationReminders: 'Location Reminders',
    kSounds: 'Sounds',
    kLanguage: 'Language',
    kAboutUs: 'ABOUT US',
    kRateApp: 'Rate Everyday Gem',
    kShareWithFriends: 'Share with Friends',
    kSupport: 'Support',
    kEditName: 'Edit Name',
    kEnterYourName: 'Enter your name',

    // Rewards
    kRewards: 'Rewards',
    kGems: 'Gems',
    kGemsToNextLevel: '{count} gems to next level',
    kAvailableRewards: 'Available Rewards',
    kNoRewardsYet: 'No rewards yet. Tap + to add one!',
    kRecentHistory: 'Recent History',
    kHabitCompleted: 'Habit completed',
    kStreakBonus: 'Streak bonus',
    kRewardRedeemed: 'Reward redeemed',
    kAddReward: 'Add Reward',
    kRewardName: 'Reward name (e.g. Ice cream)',
    kCostInGems: 'Cost in gems (e.g. 50)',
    kRedeemed: 'redeemed!',

    // Friends
    kMyInviteCode: 'My Invite Code',
    kCodeCopied: 'Code copied!',
    kShareCodeMessage: 'Share this code with friends & family',
    kPendingRequests: 'Pending Requests',
    kFriendRequest: 'Friend request',
    kNoFriendsYet: 'No friends yet',
    kShareCodeToConnect: 'Share your invite code to connect!',
    kAddFriend: 'Add Friend',
    kEnterInviteCode: 'Enter invite code',
    kRelationship: 'Relationship:',
    kFriend: 'Friend',
    kParentChild: 'Parent-Child',
    kFriendRequestSent: 'Friend request sent!',
    kCouldNotFindUser: 'Could not find user with that code',

    // Location
    kNoLocationReminders: 'No location reminders',
    kTapToAddLocation: 'Tap + to add a location-based reminder',
    kAddLocationReminder: 'Add Location Reminder',
    kLocationName: 'Location name',
    kLocationNameHint: 'Location name (e.g. Gym)',
    kTriggerWhen: 'Trigger when:',
    kArrive: 'Arrive',
    kLeave: 'Leave',
    kRadius: 'Radius: {radius}m',
    kUsesCurrentLocation: 'Uses your current location when saved.',
    kCouldNotGetLocation: 'Could not get location. Check permissions.',
    kOnArrive: 'On arrive',
    kOnLeave: 'On leave',

    // Stats
    kDetailedStats: 'Detailed Stats',
    kOverview: 'Overview',
    kMonthlyTrend: 'Monthly Trend',
    kTotalDays: 'Total Days',
    kCurrentStreak: 'Current Streak',
    kByDayOfWeek: 'By Day of Week',
    kMonthlyRate: 'Monthly Rate',

    // Level names
    kLevelSeedling: '🌱 Seedling',
    kLevelSprout: '🌿 Sprout',
    kLevelTree: '🌳 Tree',
    kLevelGem: '💎 Gem',
    kLevelDiamond: '👑 Diamond',

    // Day names
    kMon: 'M',
    kTue: 'T',
    kWed: 'W',
    kThu: 'T',
    kFri: 'F',
    kSat: 'S',
    kSun: 'S',
  };
}
