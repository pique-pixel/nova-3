import 'package:rp_mobile/layers/bloc/event_detail/event_detail_models.dart';

abstract class EventDetailService {

  Future<EventDetail> getEventDetails(String ref);

}
