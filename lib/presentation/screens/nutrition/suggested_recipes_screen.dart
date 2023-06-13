import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/presentation/providers/nutrition/search_recipes_provider.dart';
import 'package:go_router/go_router.dart';

class SuggestedRecipesScreen extends ConsumerStatefulWidget {
  final String foodType;
  const SuggestedRecipesScreen({super.key, required this.foodType});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuggestedRecipesScreenState();
}

class _SuggestedRecipesScreenState
    extends ConsumerState<SuggestedRecipesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchedRecipesProvider.notifier).loadNextPage(widget.foodType);
    });
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels + 400) >=
          _scrollController.position.maxScrollExtent) {
        ref
            .read(searchedRecipesProvider.notifier)
            .loadNextPage(widget.foodType);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(searchedRecipesProvider).suggestedRecipes;

    if (recipes.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '${widget.foodType} Suggestions',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MasonryGridView.count(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: recipes.length,
          crossAxisCount: 2,
          crossAxisSpacing: 13,
          mainAxisSpacing: 16,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return GestureDetector(
              child: _SuggestedRecipeCard(recipe: recipe),
              onTap: () => context.push('/nutrition/recipe/${recipe.id}'),
            );
          },
        ),
      ),
    );
  }
}

class _SuggestedRecipeCard extends StatelessWidget {
  final ComplexSearchRecipe recipe;

  const _SuggestedRecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: const [
            BoxShadow(
              offset: Offset(-2, -2),
              blurRadius: 12,
              color: Color.fromRGBO(0, 0, 0, 0.05),
            ),
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 5,
              color: Color.fromRGBO(0, 0, 0, 0.10),
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120.h,
              foregroundDecoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              width: double.infinity,
              child: _ImageViewer(image: recipe.image),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(9),
              child: Text(
                recipe.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textStyles.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final String image;
  const _ImageViewer({required this.image});

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          // height: 250.0,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: FadeInImage(
        fit: BoxFit.cover,
        image: NetworkImage(image),
        // height: 250,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: const AssetImage('assets/temp/bottle-loader.gif'),
      ),
    );
  }
}
