import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit() : super(TagsInitial());
}
