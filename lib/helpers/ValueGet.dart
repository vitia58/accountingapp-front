class ValueGet<T>{
  ValueGet({void Function(T v)? onChange,required T initial}){
    if(initial!=null)_v=initial;
    if(onChange!=null)_onChange=onChange;
  }
  set value(T v){
    if(v!=_v){
      _v=v;
      if(_onChange!=null) _onChange!(v);
    }
  }
  T get value=>_v;
  void Function(T v)? _onChange;
  late T _v;
}