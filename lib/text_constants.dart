class AppText {
  // App bar title
  static const String mainTitle = "說話不卡卡";
  static const String subTitle = "構音篩檢 APP";

  // Buttons & Checkboxes
  static const String startButton = "開始測驗";
  static const String submitButton = "送出";
  static const String completeButton = "完成";
  static const String returnButton = "返回";
  static const String exitButton = "退出程式";

  // Consent page
  static const String consentWelcomeMessage01 = "親愛的家長您好：\n";
  static const String consentWelcomeMessage02 =
      "「說話不卡卡」提供家長一個了解孩子語音／構音狀況的工具，藉由APP的篩檢您可以在家中就初步了解您的孩子錯誤發音的狀況，即時了解如何協助您的孩子。在與語言治療師或幼兒園教師針對孩子的錯誤發音狀況進行溝通時，此APP篩檢結果可作為討論的依據，並為孩子安排一個適合的治療方式。APP篩檢完畢後會提供相關衛教單張的連結，讓您在了解孩子的發音錯誤狀況之外，還可以有衛教訊息讓您了解如何與孩子互動或協助自己的孩子。";
  static const String consentFormMessage =
      "\t\t\t\t\t\t\t\t\t本 APP 是國泰醫院與臺灣科技大學合作設計的說話語音篩檢工具，利用人工智慧的方式進行測試，讓您可簡易了解兒童的錯誤發音情形。\n\t\t\t\t\t\t\t\t\t依保密原則及嚴密倫理守則，篩檢時您填寫的資料、與孩童透過手機麥克風所得之收音與分析結果，將彙整進研究團隊之語音資料庫中，強化人工智慧訓練的精準性並有益於往後的使用者篩檢，所有您所提供之文字、語音資料將只會作為學術研究之用途而加密保存於國泰醫院的伺服器中，請問您是否同意上述說明並使用此 APP？";
  static const String consentAgreeCheckbox = "我同意上述說明並願意參與此次試驗。";
  static const String consentSignText = "簽名";
  static const String consentSignWarn = "姓名不得為空";
  static const String consentDateText = "簽名日期";

  // Basic information page
  static const String basicInfoWelcomeMessage01 = "親愛的家長您好：\n";
  static const String basicInfoWelcomeMessage02 =
      "以下的基本資料麻煩您花 2~3 分鐘填寫。\n您所填寫的基本資料，是讓我們更了解您的孩子，此份資料不外流，請您放心填寫。";
  static const String basicInfoProgressbarText = "填寫進度";
  static const String basicInfoDialogTitle = "其他";
  static const String basicInfoDialogHint = "請輸入文字";
  static const String basicInfoDialogSubmit = "送出";

  // Record page
  static const String recordProgressbarText = "完成進度";
  static const String recordUploadingWait = "數據分析中";
  static const String recordUploadingFailed = "數據分析失敗";
  static const String recordUploadingAgain = "再試一次";

  // Result page
  static const String resultDiagnosePrefix01 = "您的孩子為";
  // PCC: 0.85~1.0
  static const String resultDiagnosisLevel01 = "輕度語言障礙。\n";
  // PCC: 0.65~0.85
  static const String resultDiagnosisLevel02 = "輕中度語言障礙。\n";
  // PCC: 0.50~0.65
  static const String resultDiagnosisLevel03 = "中重度語言障礙。\n";
  // PCC: 0.00~0.50
  static const String resultDiagnosisLevel04 = "重度語言障礙。\n";
  static const String resultDiagnosePrefix02 = "錯誤語音類型為：\n";
  // If age <= 3 && PCC >= 65% || if age > 3 && PCC >= 85%
  static const String resultAdvice01 =
      "建議可持續追蹤您的孩子語音的表現，若您擔憂可掛復健科請語言治療師進行語音評估。";
  // If age <= 3 && PCC < 65% || if age > 3 && PCC < 85%
  static const String resultAdvice02 = "建議可掛復健科找語言治療師進行評估，並接受語音的訓練。";
  static const String mapButton = "語言治療地圖";
  static const String resourceButton = "線上資源";

  // Resource page
  static const String resourceAdvice =
      "以下是更多的資源與介紹，分享給您參考，若有問題請聯繫：(02)2648-2121 分機 3652";
  static const Map<String, dynamic> resourceLinks = {
    "0": {
      "text": "語言障礙衛教相關資訊",
      "url":
          "https://drive.google.com/drive/folders/18zogvXQVgzwuvdRFj64K07nAZZmTDyNh"
    },
    "1": {
      "text": "語言治療引導和誘發小技巧",
      "url":
          "https://drive.google.com/drive/folders/1qKrnBNUdXzsFW09j7aC8IHBWRGMrneKk?usp=sharing"
    },
    "2": {
      "text": "語言治療資訊 ─ 其他專區",
      "url":
          "https://drive.google.com/drive/folders/1M7-gMW2VPL2R-LJSOFKax9w8HO8aaJG5?usp=sharing"
    },
    "3": {
      "text": "汐止國泰綜合醫院\n語言治療組衛教專區",
      "url":
          "https://drive.google.com/drive/folders/10LiJ1QpPkTyW-_9S4gEf_Twa582urH0R?usp=sharing"
    }
  };

  // Treatment map page
  static const String mapAdvice =
      "以下是更多的資源與介紹，分享給您參考，若有問題請聯繫：(02)2648-2121 分機 3652";
  static const String mapTaiwan = "全台語言治療地圖";
  static const String mapTaiwanHint = "";
  static const String mapTaipei = "雙北語言治療地圖";
  static const String mapTaipeiHint = "地圖更新至 2021 年初";

  // Questions
  static const Map<String, dynamic> jsonQuestionInfoString = {
    "1": {
      "question": "姓名 & 生日",
      "options": ["兒童姓名", "出生日期"],
      "multiselect": false
    },
    "2": {
      "question": "您的孩子性別？",
      "options": ["男生", "女生"],
      "multiselect": false
    },
    "3": {
      "question": "請問孩子是否有手足(兄弟姐妹)？",
      "options": ["有", "沒有"],
      "multiselect": false
    },
    "4": {
      "question": "請問家屬親人中是否有以下語言發展的情況？(可複選)",
      "options": [
        "口吃",
        "語言發展遲緩",
        "說話性語音障礙（俗稱大舌頭）",
        "嗓音障礙（如：沙啞）",
        "吞嚥障礙",
        "學習障礙",
        "無"
      ],
      "multiselect": true
    },
    "5": {
      "question": "請問母親懷孕時的情況？",
      "options": ["良好", "須安胎", "早產", "曾服用過長時間的藥物"],
      "multiselect": true
    },
    "6": {
      "question": "請問孩子的進食情況？",
      "options": ["良好", "挑食", "進食時間久(1餐須超過1小時)", "咀嚼困難", "流口水", "其他"],
      "multiselect": true
    },
    "7": {
      "question": "請問您的孩子呼吸情況？",
      "options": ["良好", "易有哮喘聲", "由口呼吸"],
      "multiselect": true
    },
    "8": {
      "question": "您的孩子是否曾經或現在有以下的情況？",
      "options": [
        "語言發展遲緩",
        "聽力障礙",
        "支氣管炎",
        "哮喘",
        "氣喘",
        "過敏",
        "意力缺損過動症(ADHD)",
        "自閉症",
        "其他",
        "無"
      ],
      "multiselect": true
    },
    "9": {
      "question": "您的孩子何時開口說話？(開口說第一個有意義的語言如:爸爸媽媽)",
      "options": ["1 歲", "1 歲半", "2 歲", "超過兩歲"],
      "multiselect": false
    },
    "10": {
      "question": "您的孩子是否曾經/或現在接受過相關療育？(可複選)",
      "options": ["物理治療", "職能治療", "心理治療", "語言治療", "其他", "無"],
      "multiselect": true
    }
  };
  static const Map<String, dynamic> jsonQuestionRecordString = {
    "0": {
      "word": "大哭",
      "transcript": "wordcard03_01",
      "img": "assets/image/card/大哭.png"
    },
    "1": {
      "word": "打鼓",
      "transcript": "wordcard03_02",
      "img": "assets/image/card/打鼓.png"
    },
    "2": {
      "word": "積木",
      "transcript": "wordcard03_03",
      "img": "assets/image/card/積木.png"
    },
    "3": {
      "word": "踏步",
      "transcript": "wordcard03_04",
      "img": "assets/image/card/踏步.png"
    },
    "4": {
      "word": "吉他",
      "transcript": "wordcard03_05",
      "img": "assets/image/card/吉他.png"
    },
    "5": {
      "word": "哈囉",
      "transcript": "wordcard03_06",
      "img": "assets/image/card/哈囉.png"
    },
    "6": {
      "word": "內褲",
      "transcript": "wordcard03_07",
      "img": "assets/image/card/內褲.png"
    },
    "7": {
      "word": "骨頭",
      "transcript": "wordcard03_08",
      "img": "assets/image/card/骨頭.png"
    },
    "8": {
      "word": "頭髮",
      "transcript": "wordcard04_01",
      "img": "assets/image/card/頭髮.png"
    },
    "9": {
      "word": "枇杷",
      "transcript": "wordcard04_02",
      "img": "assets/image/card/枇杷.png"
    },
    "10": {
      "word": "旗子",
      "transcript": "wordcard04_03",
      "img": "assets/image/card/旗子.png"
    },
    "11": {
      "word": "欺負",
      "transcript": "wordcard04_04",
      "img": "assets/image/card/欺負.png"
    },
    "12": {
      "word": "擦藥",
      "transcript": "wordcard04_05",
      "img": "assets/image/card/擦藥.png"
    },
    "13": {
      "word": "草莓",
      "transcript": "wordcard04_06",
      "img": "assets/image/card/草莓.png"
    },
    "14": {
      "word": "走路",
      "transcript": "wordcard04_07",
      "img": "assets/image/card/走路.png"
    },
    "15": {
      "word": "山上",
      "transcript": "wordcard04fcdp_01",
      "img": "assets/image/card/山上.png"
    },
    "16": {
      "word": "綿羊",
      "transcript": "wordcard04fcdp_02",
      "img": "assets/image/card/綿羊.png"
    },
    "17": {
      "word": "聲音",
      "transcript": "wordcard04fcdp_03",
      "img": "assets/image/card/聲音.png"
    },
    "18": {
      "word": "星星",
      "transcript": "wordcard04fcdp_04",
      "img": "assets/image/card/星星.png"
    },
    "19": {
      "word": "日曆",
      "transcript": "wordcard05_01",
      "img": "assets/image/card/日曆.png"
    },
    "20": {
      "word": "蜘蛛",
      "transcript": "wordcard05_02",
      "img": "assets/image/card/蜘蛛.png"
    },
    "21": {
      "word": "住宿",
      "transcript": "wordcard05_03",
      "img": "assets/image/card/住宿.png"
    },
    "22": {
      "word": "洗手",
      "transcript": "wordcard05_04",
      "img": "assets/image/card/洗手.png"
    },
    "23": {
      "word": "抽屜",
      "transcript": "wordcard05_05",
      "img": "assets/image/card/抽屜.png"
    },
    "24": {
      "word": "下車",
      "transcript": "wordcard05_06",
      "img": "assets/image/card/下車.png"
    },
    "25": {
      "word": "梳子",
      "transcript": "wordcard05_07",
      "img": "assets/image/card/梳子.png"
    },
    "26": {
      "word": "吐司",
      "transcript": "wordcard05_08",
      "img": "assets/image/card/吐司.png"
    }
  };
}
