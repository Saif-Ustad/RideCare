import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/usecases/category/get_all_categories_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;

  CategoryBloc({required this.getAllCategoriesUseCase})
    : super(CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final List<CategoryEntity> categories =
            await getAllCategoriesUseCase.call();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
