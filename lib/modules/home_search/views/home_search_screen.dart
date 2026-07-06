import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../constant/const_string.dart';
import '../../../data/models/word_entry.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/common/empty_state_widget.dart';
import '../../../widget/common/skeleton_loader.dart';
import '../../../widget/dictionary/headword_row.dart';
import '../../../widget/dictionary/pos_chip.dart';
import '../../../widget/dictionary/section_label.dart';
import '../../../widget/dictionary/squiggle_underline.dart';
import '../../../widget/dictionary/word_result_row.dart';
import '../controllers/home_search_controller.dart';

class HomeSearchScreen extends GetView<HomeSearchController> {
  const HomeSearchScreen({super.key});

  void _openWord(String headword) {
    Get.toNamed(AppRoutes.wordDetailScreen, arguments: headword)?.then((_) => controller.refreshRecentSearches());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.s5.w, AppSpacing.s3.h, AppSpacing.s5.w, AppSpacing.s2.h),
              child: Text(ConstString.appName, style: AppTypography.headwordLg()),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s5.w),
              child: _SearchBar(controller: controller),
            ),
            SizedBox(height: AppSpacing.s3.h),
            Expanded(
              child: Obx(() {
                switch (controller.status.value) {
                  case SearchStatus.idle:
                    return _HomeContent(controller: controller, onOpenWord: _openWord);
                  case SearchStatus.loading:
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s2.h),
                      itemCount: 6,
                      itemBuilder: (_, __) => const WordResultRowSkeleton(),
                    );
                  case SearchStatus.empty:
                    return _NoResults(controller: controller, onOpenWord: _openWord);
                  case SearchStatus.results:
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w),
                      itemCount: controller.results.length,
                      itemBuilder: (context, index) {
                        final headword = controller.results[index];
                        final cached = controller.peekCached(headword);
                        if (cached != null) {
                          return WordResultRow(
                            entry: cached,
                            highlighted: index == 0,
                            onTap: () => _openWord(headword),
                          );
                        }
                        return HeadwordRow(
                          headword: headword,
                          highlighted: index == 0,
                          onTap: () => _openWord(headword),
                        );
                      },
                    );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final HomeSearchController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: AppMotion.fast,
            decoration: BoxDecoration(
              color: hasFocus ? AppColors.bgPaperRaised : AppColors.bgPaperSunken,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: hasFocus ? AppColors.marigold : Colors.transparent, width: 1),
              boxShadow: hasFocus
                  ? [BoxShadow(color: AppColors.ink900.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))]
                  : null,
            ),
            child: Row(
              children: [
                SizedBox(width: AppSpacing.s3.w),
                Icon(Icons.search_rounded, size: 20.sp, color: AppColors.ink500),
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    onChanged: controller.onQueryChanged,
                    style: AppTypography.bodyLg(),
                    decoration: InputDecoration(
                      hintText: ConstString.searchHint,
                      hintStyle: AppTypography.bodyLg(color: AppColors.ink300),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w, vertical: 14.h),
                    ),
                  ),
                ),
                Obx(
                  () => controller.query.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close_rounded, size: 18.sp, color: AppColors.ink500),
                          onPressed: controller.clearQuery,
                        )
                      : SizedBox(width: AppSpacing.s2.w),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeSearchController controller;
  final ValueChanged<String> onOpenWord;
  const _HomeContent({required this.controller, required this.onOpenWord});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(AppSpacing.s5.w, AppSpacing.s2.h, AppSpacing.s5.w, AppSpacing.s10.h),
      children: [
        Obx(() {
          final word = controller.wordOfTheDay.value;
          if (word == null) return const SizedBox.shrink();
          return _WordOfTheDayCard(entry: word, onTap: () => onOpenWord(word.headword));
        }),
        SizedBox(height: AppSpacing.s6.h),
        Obx(() {
          if (controller.recentSearches.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionLabel(text: ConstString.recentSearches),
                  TextButton(
                    onPressed: controller.clearRecentSearches,
                    child: Text(ConstString.clear, style: AppTypography.labelSm(color: AppColors.ink500)),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s2.h),
              Wrap(
                spacing: AppSpacing.s2.w,
                runSpacing: AppSpacing.s2.h,
                children: controller.recentSearches
                    .map((w) => _ChipButton(label: w, onTap: () => onOpenWord(w)))
                    .toList(),
              ),
              SizedBox(height: AppSpacing.s6.h),
            ],
          );
        }),
        Obx(() {
          if (controller.exploreWords.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(text: ConstString.explore),
              SizedBox(height: AppSpacing.s2.h),
              ...controller.exploreWords.map(
                (entry) => WordResultRow(entry: entry, onTap: () => onOpenWord(entry.headword)),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _WordOfTheDayCard extends StatelessWidget {
  final WordEntry entry;
  final VoidCallback onTap;
  const _WordOfTheDayCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.s4.w),
        decoration: BoxDecoration(
          color: AppColors.bgPaperRaised,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [BoxShadow(color: AppColors.ink900.withAlpha(15), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ConstString.wordOfTheDay.toUpperCase(), style: AppTypography.labelMd(color: AppColors.marigold)),
            SizedBox(height: AppSpacing.s2.h),
            Row(
              children: [
                Text(entry.headword, style: AppTypography.headwordLg()),
                SizedBox(width: AppSpacing.s2.w),
                PosChip(partOfSpeech: entry.primaryPartOfSpeech),
              ],
            ),
            SizedBox(height: 4.h),
            Text(entry.phonetic, style: AppTypography.monoPhonetic(color: AppColors.ink500)),
            SizedBox(height: AppSpacing.s2.h),
            Text(
              entry.previewDefinition,
              style: AppTypography.bodyMd(color: AppColors.ink700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ChipButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.bgPaperSunken,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(label, style: AppTypography.bodyMd(color: AppColors.ink700)),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final HomeSearchController controller;
  final ValueChanged<String> onOpenWord;
  const _NoResults({required this.controller, required this.onOpenWord});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: ConstString.noMatchesFor.replaceAll('%s', controller.query.value),
          body: ConstString.checkSpelling,
          extra: controller.suggestions.isEmpty
              ? null
              : [
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.s2.w,
                    runSpacing: AppSpacing.s2.h,
                    children: controller.suggestions
                        .map((w) => _ChipButton(label: w, onTap: () => onOpenWord(w)))
                        .toList(),
                  ),
                ],
        ),
      ),
    );
  }
}
