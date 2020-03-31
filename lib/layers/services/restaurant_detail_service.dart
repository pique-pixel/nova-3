import 'package:rp_mobile/layers/bloc/restaurant_detail/restaurant_detail_models.dart';

abstract class RestaurantDetailService {

  Future<RestaurantDetail> getRestaurantDetails(String ref);

}
