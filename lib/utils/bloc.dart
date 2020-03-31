abstract class CascadeState<T> {
  T get prevState;
  bool get hasTriggeredRoute;
}

T unwindCascadeState<T>(T state) {
  return state is CascadeState ? state.prevState : state;
}
