enum Category {
  Education,
  Transportation,
  Other,
  LargeMart,
  Beauty,
  Delivery,
  Insurance,
  DailyNecessities,
  LivingServices,
  TaxesAndFees,
  ShoppingMall,
  TravelAndAccommodation,
  DiningOut,
  Healthcare,
  AlcoholAndPub,
  HobbiesAndLeisure,
  Cafe,
  Communication,
  ConvenienceStore,
}

// 카테고리 문자열을 enum으로 변환할 때 사용
Category categoryFromString(String value) {
  switch (value) {
    case '교육':
      return Category.Education;
    case '교통_자동차':
    case '교통/자동차': // 슬래시와 언더스코어 모두 지원
      return Category.Transportation;
    case '기타소비':
      return Category.Other;
    case '대형마트':
      return Category.LargeMart;
    case '미용':
      return Category.Beauty;
    case '배달':
      return Category.Delivery;
    case '보험':
      return Category.Insurance;
    case '생필품':
      return Category.DailyNecessities;
    case '생활서비스':
      return Category.LivingServices;
    case '세금_공과금':
    case '세금/공과금': // 슬래시와 언더스코어 모두 지원
      return Category.TaxesAndFees;
    case '쇼핑몰':
      return Category.ShoppingMall;
    case '여행_숙박':
    case '여행/숙박': // 슬래시와 언더스코어 모두 지원
      return Category.TravelAndAccommodation;
    case '외식':
      return Category.DiningOut;
    case '의료_건강':
    case '의료/건강': // 슬래시와 언더스코어 모두 지원
      return Category.Healthcare;
    case '주류_펍':
    case '주류/펍': // 슬래시와 언더스코어 모두 지원
      return Category.AlcoholAndPub;
    case '취미_여가':
    case '취미/여가': // 슬래시와 언더스코어 모두 지원
      return Category.HobbiesAndLeisure;
    case '카페':
      return Category.Cafe;
    case '통신':
      return Category.Communication;
    case '편의점':
      return Category.ConvenienceStore;
    default:
    // 변환 실패 시 예외를 던지기 전 로그를 남길 수 있습니다.
      print('Unknown category string: $value');
      throw ArgumentError('Unknown category: $value');
  }
}

// 데이터 처리용
String categoryToStringDown(Category category) {
  switch (category) {
    case Category.Education:
      return '교육';
    case Category.Transportation:
      return '교통_자동차';
    case Category.Other:
      return '기타소비';
    case Category.LargeMart:
      return '대형마트';
    case Category.Beauty:
      return '미용';
    case Category.Delivery:
      return '배달';
    case Category.Insurance:
      return '보험';
    case Category.DailyNecessities:
      return '생필품';
    case Category.LivingServices:
      return '생활서비스';
    case Category.TaxesAndFees:
      return '세금_공과금';
    case Category.ShoppingMall:
      return '쇼핑몰';
    case Category.TravelAndAccommodation:
      return '여행_숙박';
    case Category.DiningOut:
      return '외식';
    case Category.Healthcare:
      return '의료_건강';
    case Category.AlcoholAndPub:
      return '주류_펍';
    case Category.HobbiesAndLeisure:
      return '취미_여가';
    case Category.Cafe:
      return '카페';
    case Category.Communication:
      return '통신';
    case Category.ConvenienceStore:
      return '편의점';
    default:
      print('Unknown category enum: $category');
      throw ArgumentError('Unknown category: $category');
  }
}

// 보여주는용
String categoryToString(Category category) {
  switch (category) {
    case Category.Education:
      return '교육';
    case Category.Transportation:
      return '교통/자동차';
    case Category.Other:
      return '기타소비';
    case Category.LargeMart:
      return '대형마트';
    case Category.Beauty:
      return '미용';
    case Category.Delivery:
      return '배달';
    case Category.Insurance:
      return '보험';
    case Category.DailyNecessities:
      return '생필품';
    case Category.LivingServices:
      return '생활서비스';
    case Category.TaxesAndFees:
      return '세금/공과금';
    case Category.ShoppingMall:
      return '쇼핑몰';
    case Category.TravelAndAccommodation:
      return '여행/숙박';
    case Category.DiningOut:
      return '외식';
    case Category.Healthcare:
      return '의료/건강';
    case Category.AlcoholAndPub:
      return '주류/펍';
    case Category.HobbiesAndLeisure:
      return '취미/여가';
    case Category.Cafe:
      return '카페';
    case Category.Communication:
      return '통신';
    case Category.ConvenienceStore:
      return '편의점';
    default:
      print('Unknown category enum: $category');
      throw ArgumentError('Unknown category: $category');
  }
}
