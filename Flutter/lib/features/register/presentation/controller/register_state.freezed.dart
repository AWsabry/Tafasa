// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterState {

 int get currentStep; bool get obscurePassword; bool get obscureConfirmPassword; bool get acceptTerms;
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateCopyWith<RegisterState> get copyWith => _$RegisterStateCopyWithImpl<RegisterState>(this as RegisterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword)&&(identical(other.acceptTerms, acceptTerms) || other.acceptTerms == acceptTerms));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,obscurePassword,obscureConfirmPassword,acceptTerms);

@override
String toString() {
  return 'RegisterState(currentStep: $currentStep, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, acceptTerms: $acceptTerms)';
}


}

/// @nodoc
abstract mixin class $RegisterStateCopyWith<$Res>  {
  factory $RegisterStateCopyWith(RegisterState value, $Res Function(RegisterState) _then) = _$RegisterStateCopyWithImpl;
@useResult
$Res call({
 int currentStep, bool obscurePassword, bool obscureConfirmPassword, bool acceptTerms
});




}
/// @nodoc
class _$RegisterStateCopyWithImpl<$Res>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._self, this._then);

  final RegisterState _self;
  final $Res Function(RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? obscurePassword = null,Object? obscureConfirmPassword = null,Object? acceptTerms = null,}) {
  return _then(_self.copyWith(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,acceptTerms: null == acceptTerms ? _self.acceptTerms : acceptTerms // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Failure():
return failure(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)?  initial,TResult Function( int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)?  loading,TResult Function( String message,  int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)?  success,TResult Function( Failure failure,  int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Loading() when loading != null:
return loading(_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Success() when success != null:
return success(_that.message,_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Failure() when failure != null:
return failure(_that.failure,_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)  initial,required TResult Function( int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)  loading,required TResult Function( String message,  int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)  success,required TResult Function( Failure failure,  int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Loading():
return loading(_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Success():
return success(_that.message,_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Failure():
return failure(_that.failure,_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)?  initial,TResult? Function( int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)?  loading,TResult? Function( String message,  int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)?  success,TResult? Function( Failure failure,  int currentStep,  bool obscurePassword,  bool obscureConfirmPassword,  bool acceptTerms)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Loading() when loading != null:
return loading(_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Success() when success != null:
return success(_that.message,_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _Failure() when failure != null:
return failure(_that.failure,_that.currentStep,_that.obscurePassword,_that.obscureConfirmPassword,_that.acceptTerms);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends RegisterState {
  const _Initial({this.currentStep = 0, this.obscurePassword = true, this.obscureConfirmPassword = true, this.acceptTerms = false}): super._();
  

@override@JsonKey() final  int currentStep;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  bool obscureConfirmPassword;
@override@JsonKey() final  bool acceptTerms;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword)&&(identical(other.acceptTerms, acceptTerms) || other.acceptTerms == acceptTerms));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,obscurePassword,obscureConfirmPassword,acceptTerms);

@override
String toString() {
  return 'RegisterState.initial(currentStep: $currentStep, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, acceptTerms: $acceptTerms)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 int currentStep, bool obscurePassword, bool obscureConfirmPassword, bool acceptTerms
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? obscurePassword = null,Object? obscureConfirmPassword = null,Object? acceptTerms = null,}) {
  return _then(_Initial(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,acceptTerms: null == acceptTerms ? _self.acceptTerms : acceptTerms // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Loading extends RegisterState {
  const _Loading({this.currentStep = 0, this.obscurePassword = true, this.obscureConfirmPassword = true, this.acceptTerms = false}): super._();
  

@override@JsonKey() final  int currentStep;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  bool obscureConfirmPassword;
@override@JsonKey() final  bool acceptTerms;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword)&&(identical(other.acceptTerms, acceptTerms) || other.acceptTerms == acceptTerms));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,obscurePassword,obscureConfirmPassword,acceptTerms);

@override
String toString() {
  return 'RegisterState.loading(currentStep: $currentStep, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, acceptTerms: $acceptTerms)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@override @useResult
$Res call({
 int currentStep, bool obscurePassword, bool obscureConfirmPassword, bool acceptTerms
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? obscurePassword = null,Object? obscureConfirmPassword = null,Object? acceptTerms = null,}) {
  return _then(_Loading(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,acceptTerms: null == acceptTerms ? _self.acceptTerms : acceptTerms // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Success extends RegisterState {
  const _Success({required this.message, this.currentStep = 0, this.obscurePassword = true, this.obscureConfirmPassword = true, this.acceptTerms = false}): super._();
  

 final  String message;
@override@JsonKey() final  int currentStep;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  bool obscureConfirmPassword;
@override@JsonKey() final  bool acceptTerms;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.message, message) || other.message == message)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword)&&(identical(other.acceptTerms, acceptTerms) || other.acceptTerms == acceptTerms));
}


@override
int get hashCode => Object.hash(runtimeType,message,currentStep,obscurePassword,obscureConfirmPassword,acceptTerms);

@override
String toString() {
  return 'RegisterState.success(message: $message, currentStep: $currentStep, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, acceptTerms: $acceptTerms)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@override @useResult
$Res call({
 String message, int currentStep, bool obscurePassword, bool obscureConfirmPassword, bool acceptTerms
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? currentStep = null,Object? obscurePassword = null,Object? obscureConfirmPassword = null,Object? acceptTerms = null,}) {
  return _then(_Success(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,acceptTerms: null == acceptTerms ? _self.acceptTerms : acceptTerms // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Failure extends RegisterState {
  const _Failure({required this.failure, this.currentStep = 0, this.obscurePassword = true, this.obscureConfirmPassword = true, this.acceptTerms = false}): super._();
  

 final  Failure failure;
@override@JsonKey() final  int currentStep;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  bool obscureConfirmPassword;
@override@JsonKey() final  bool acceptTerms;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.obscureConfirmPassword, obscureConfirmPassword) || other.obscureConfirmPassword == obscureConfirmPassword)&&(identical(other.acceptTerms, acceptTerms) || other.acceptTerms == acceptTerms));
}


@override
int get hashCode => Object.hash(runtimeType,failure,currentStep,obscurePassword,obscureConfirmPassword,acceptTerms);

@override
String toString() {
  return 'RegisterState.failure(failure: $failure, currentStep: $currentStep, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, acceptTerms: $acceptTerms)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@override @useResult
$Res call({
 Failure failure, int currentStep, bool obscurePassword, bool obscureConfirmPassword, bool acceptTerms
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? currentStep = null,Object? obscurePassword = null,Object? obscureConfirmPassword = null,Object? acceptTerms = null,}) {
  return _then(_Failure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,obscureConfirmPassword: null == obscureConfirmPassword ? _self.obscureConfirmPassword : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,acceptTerms: null == acceptTerms ? _self.acceptTerms : acceptTerms // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
