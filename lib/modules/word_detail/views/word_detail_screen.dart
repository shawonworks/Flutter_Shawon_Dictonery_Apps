import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../constant/const_string.dart';
import '../../../data/models/meaning.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/appbar/global_app_bar.dart';
import '../../../widget/common/empty_state_widget.dart';
import '../../../widget/common/segmented_control.dart';
import '../../../widget/common/app_snackbar.dart';
import '../../../widget/dictionary/audio_play_button.dart';
import '../../../widget/dictionary/favorite_star_button.dart';
import '../../../widget/dictionary/pos_chip.dart';
import '../../../widget/dictionary/section_label.dart';
import '../../../widget/dictionary/squiggle_underline.dart';
import '../controllers/word_detail_controller.dart';

class WordDetailScreen extends StatefulWidget {
  const WordDetailScreen({super.key});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final RxBool _raised = false.obs;
  late final String headword;
  late final WordDetailController controller;

  @override
  void initState() {
    super.initState();
    headword = Get.arguments as String? ?? '';
    controller = Get.find<WordDetailController>(tag: headword);
    _scrollController.addListener(() {
      _raised.value = _scrollController.hasClients && _scrollController.offset > 4;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openWord(String word) {
    Get.toNamed(AppRoutes.wordDetailScreen, arguments: word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: Obx(
          () => GlobalAppBar(
            raised: _raised.value,
            actions: [
            Obx(
              () => FavoriteStarButton(
                isFavorite: controller.isFavorite.value,
                onToggle: () {
                  final wasFavorite = controller.isFavorite.value;
                  controller.toggleFavorite();
                  AppSnackbar.show(
                    wasFavorite ? ConstString.removedFromFavorites : ConstString.addedToFavorites,
                    actionLabel: wasFavorite ? null : ConstString.undo,
                    onAction: wasFavorite ? null : controller.toggleFavorite,
                  );
                },
              ),
            ),
              IconButton(
                icon: Icon(Icons.ios_share_rounded, size: 20.sp, color: AppColors.ink500),
                onPressed: () => SharePlus.instance.share(ShareParams(text: controller.sharePreviewText)),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorType.value != WordDetailErrorType.none || controller.entry.value == null) {
          final notFound = controller.errorType.value == WordDetailErrorType.notFound;
          return EmptyStateWidget(
            icon: notFound ? Icons.search_off_rounded : Icons.wifi_off_rounded,
            title: notFound ? ConstString.wordNotFound : ConstString.somethingWentWrong,
            body: notFound ? null : ConstString.checkConnection,
            isError: true,
            actionLabel: notFound ? null : ConstString.tryAgain,
            onAction: notFound ? null : controller.retry,
          );
        }

        final entry = controller.entry.value!;
        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(AppSpacing.s5.w, AppSpacing.s3.h, AppSpacing.s5.w, AppSpacing.s10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.headword, style: AppTypography.headwordXl()),
              SizedBox(height: 6.h),
              const SquiggleUnderline(width: 32, strokeWidth: 3),
              SizedBox(height: AppSpacing.s4.h),
              Row(
                children: [
                  Text(entry.phonetic, style: AppTypography.monoPhonetic(color: AppColors.ink500)),
                  SizedBox(width: AppSpacing.s3.w),
                  Obx(
                    () => AudioPlayButton(
                      isPlaying: controller.isPlayingAudio.value,
                      onTap: controller.togglePlayback,
                    ),
                  ),
                  const Spacer(),
                  PosChip(partOfSpeech: entry.primaryPartOfSpeech),
                ],
              ),
              SizedBox(height: AppSpacing.s2.h),
              Obx(() {
                final bn = controller.entry.value?.bnHeadword;
                if (bn == null) {
                  return controller.isTranslating.value
                      ? Row(
                          children: [
                            SizedBox(
                              width: 12.sp,
                              height: 12.sp,
                              child: CircularProgressIndicator(strokeWidth: 1.6, color: AppColors.ink300),
                            ),
                            SizedBox(width: AppSpacing.s2.w),
                            Text(ConstString.translating, style: AppTypography.labelSm(color: AppColors.ink300)),
                          ],
                        )
                      : const SizedBox.shrink();
                }
                return Text('বাংলা: $bn', style: AppTypography.bodyMd(color: AppColors.sage));
              }),
              SizedBox(height: AppSpacing.s6.h),
              const SectionLabel(text: ConstString.meanings),
              SizedBox(height: AppSpacing.s3.h),
              if (entry.meanings.length > 1)
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.s4.h),
                    child: AppSegmentedControl(
                      labels: entry.meanings.map((m) => _posLabel(m.partOfSpeech)).toList(),
                      selectedIndex: controller.selectedMeaningTabIndex.value,
                      onChanged: controller.selectMeaningTab,
                    ),
                  ),
                ),
              Obx(() {
                final index = controller.selectedMeaningTabIndex.value.clamp(0, entry.meanings.length - 1);
                final meaning = entry.meanings[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(meaning.definitions.length, (i) {
                    final def = meaning.definitions[i];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.s4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 22.w,
                            child: Text('${i + 1}.', style: AppTypography.bodyLg(color: AppColors.ink300)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(def.text, style: AppTypography.bodyLg()),
                                if (def.example != null) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    def.example!,
                                    style: AppTypography.bodyMd(color: AppColors.ink500).copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                                if (def.bnText != null) ...[
                                  SizedBox(height: 4.h),
                                  Text(def.bnText!, style: AppTypography.bodyMd(color: AppColors.sage)),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }),
              if (entry.synonyms.isNotEmpty) ...[
                SizedBox(height: AppSpacing.s2.h),
                const SectionLabel(text: ConstString.synonyms),
                SizedBox(height: AppSpacing.s3.h),
                _ChipWrapRow(words: entry.synonyms, onTap: _openWord),
              ],
              if (entry.antonyms.isNotEmpty) ...[
                SizedBox(height: AppSpacing.s6.h),
                const SectionLabel(text: ConstString.antonyms),
                SizedBox(height: AppSpacing.s3.h),
                _ChipWrapRow(words: entry.antonyms, onTap: _openWord),
              ],
              if (entry.relatedForms.isNotEmpty) ...[
                SizedBox(height: AppSpacing.s6.h),
                const SectionLabel(text: ConstString.relatedWords),
                SizedBox(height: AppSpacing.s3.h),
                _ChipWrapRow(words: entry.relatedForms, onTap: null),
              ],
              SizedBox(height: AppSpacing.s8.h),
              Center(
                child: TextButton(
                  onPressed: () => AppSnackbar.show(ConstString.copiedToClipboard),
                  child: Text(
                    ConstString.reportIssue,
                    style: AppTypography.labelSm(color: AppColors.ink300),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _posLabel(PartOfSpeech pos) {
    switch (pos) {
      case PartOfSpeech.noun:
        return 'Noun';
      case PartOfSpeech.verb:
        return 'Verb';
      case PartOfSpeech.adjective:
        return 'Adjective';
      case PartOfSpeech.adverb:
        return 'Adverb';
      case PartOfSpeech.other:
        return 'Word';
    }
  }
}

class _ChipWrapRow extends StatelessWidget {
  final List<String> words;
  final ValueChanged<String>? onTap;

  const _ChipWrapRow({required this.words, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s2.w,
      runSpacing: AppSpacing.s2.h,
      children: words
          .map(
            (w) => GestureDetector(
              onTap: onTap != null ? () => onTap!(w) : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.bgPaperSunken,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(w, style: AppTypography.bodyMd(color: AppColors.ink700)),
              ),
            ),
          )
          .toList(),
    );
  }
}
