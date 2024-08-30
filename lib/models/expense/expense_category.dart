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

Category categoryFromString(String value) {
  switch (value) {
    case '교육':
      return Category.Education;
    case '교통_자동차':
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
      return Category.TaxesAndFees;
    case '쇼핑몰':
      return Category.ShoppingMall;
    case '여행_숙박':
      return Category.TravelAndAccommodation;
    case '외식':
      return Category.DiningOut;
    case '의료_건강':
      return Category.Healthcare;
    case '주류_펍':
      return Category.AlcoholAndPub;
    case '취미_여가':
      return Category.HobbiesAndLeisure;
    case '카페':
      return Category.Cafe;
    case '통신':
      return Category.Communication;
    case '편의점':
      return Category.ConvenienceStore;
    default:
      throw ArgumentError('Unknown category: $value');
  }
}
