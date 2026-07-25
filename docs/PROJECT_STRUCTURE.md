# Project Structure

## Complete Directory Tree

```text
muslim_app/
├── assets/
│   ├── audio/
│   │   └── salat_ala_nabi_sound_1.mp3
│   ├── fonts/
│   │   ├── amiri_quran/
│   │   │   └── AmiriQuran-Regular.ttf
│   │   └── cairo/
│   │       ├── Cairo-Bold.ttf
│   │       └── Cairo-Medium.ttf
│   ├── images/                          (empty)
│   ├── json/
│   │   ├── asma_ul_husna.json
│   │   ├── azkar/
│   │   │   ├── 1.json
│   │   │   ├── 10.json
│   │   │   ├── 11.json
│   │   │   ├── 12.json
│   │   │   ├── 13.json
│   │   │   ├── 14.json
│   │   │   ├── 15.json
│   │   │   ├── 16.json
│   │   │   ├── 17.json
│   │   │   ├── 18.json
│   │   │   ├── 19.json
│   │   │   ├── 2.json
│   │   │   ├── 20.json
│   │   │   ├── 21.json
│   │   │   ├── 22.json
│   │   │   ├── 23.json
│   │   │   ├── 3.json
│   │   │   ├── 4.json
│   │   │   ├── 5.json
│   │   │   ├── 6.json
│   │   │   ├── 7.json
│   │   │   ├── 8.json
│   │   │   ├── 9.json
│   │   │   ├── ablution.json
│   │   │   ├── adhan.json
│   │   │   ├── after_prayer.json
│   │   │   ├── categories.json
│   │   │   ├── children.json
│   │   │   ├── clothes.json
│   │   │   ├── death.json
│   │   │   ├── distress_worry.json
│   │   │   ├── evening.json
│   │   │   ├── fasting.json
│   │   │   ├── food_drink.json
│   │   │   ├── funeral.json
│   │   │   ├── home.json
│   │   │   ├── marriage.json
│   │   │   ├── morning.json
│   │   │   ├── mosque.json
│   │   │   ├── opening_supplication.json
│   │   │   ├── praising_allah.json
│   │   │   ├── repentance_seeking_forgiveness.json
│   │   │   ├── restroom.json
│   │   │   ├── sickness.json
│   │   │   ├── sleep.json
│   │   │   ├── travel.json
│   │   │   ├── version.json
│   │   │   └── waking_up.json
│   │   ├── azkar.json
│   │   ├── daily_content.json
│   │   ├── prayer_status.json
│   │   ├── religious_event.json
│   │   └── teaching_prayer.json
│   ├── native/
│   │   ├── app_icon.png
│   │   └── splash.png
│   └── svgs/
│       └── logo.svg
├── docs/
│   └── feature_azkar.md
├── lib/
│   ├── core/
│   │   ├── bootstrap/
│   │   │   ├── app_error_handler.dart
│   │   │   ├── firebase_bootstrapper.dart
│   │   │   ├── heavy_services_bootstrapper.dart
│   │   │   └── lifecycle_manager.dart
│   │   ├── common/
│   │   │   ├── buttons/
│   │   │   │   ├── app_buttons.dart
│   │   │   │   ├── app_delete_button.dart
│   │   │   │   ├── custom_arrow_back_button.dart
│   │   │   │   └── lightbulb_button.dart
│   │   │   ├── cards/
│   │   │   │   └── daily_content_base_card.dart
│   │   │   ├── decorations/
│   │   │   │   ├── custom_app_card_decoration.dart
│   │   │   │   └── feature_card_decoration.dart
│   │   │   ├── favorites/
│   │   │   │   ├── custom_favorite_toggle_button.dart
│   │   │   │   └── no_favorites_yet.dart
│   │   │   ├── layout/
│   │   │   │   ├── custom_carousel_slider.dart
│   │   │   │   └── responsive_wrapper.dart
│   │   │   ├── overlays/
│   │   │   │   ├── bottom_sheet/
│   │   │   │   │   ├── app_bottom_sheet.dart
│   │   │   │   │   └── theme_mode_selector_bottom_sheet.dart
│   │   │   │   ├── dialog/
│   │   │   │   │   ├── app_dialog.dart
│   │   │   │   │   ├── custom_confirmation_dialog.dart
│   │   │   │   │   ├── custom_dialog.dart
│   │   │   │   │   ├── custom_info_dialog.dart
│   │   │   │   │   ├── custom_rich_content_dialog.dart
│   │   │   │   │   ├── daily_content_explanation_dialog.dart
│   │   │   │   │   ├── permission_rationale_dialog.dart
│   │   │   │   │   └── secret_pin_dialog.dart
│   │   │   │   └── toast/
│   │   │   │       ├── app_toast.dart
│   │   │   │       ├── app_toast_models.dart
│   │   │   │       └── favorite_toast.dart
│   │   │   ├── slivers/
│   │   │   │   ├── animated_sliver_list.dart
│   │   │   │   └── common_sliver_app_bar.dart
│   │   │   ├── widgets/
│   │   │   │   ├── app_action_card.dart
│   │   │   │   ├── app_arrow_icon.dart
│   │   │   │   ├── app_custom_item_card.dart
│   │   │   │   ├── app_empty_view.dart
│   │   │   │   ├── app_error_view.dart
│   │   │   │   ├── app_gap.dart
│   │   │   │   ├── app_section_card.dart
│   │   │   │   ├── app_selection_card.dart
│   │   │   │   ├── app_text_field.dart
│   │   │   │   ├── app_toggle_list.dart
│   │   │   │   ├── custom_app_divider.dart
│   │   │   │   └── not_found_view.dart
│   │   │   └── common.dart
│   │   ├── constants/
│   │   │   ├── api_endpoints.dart
│   │   │   ├── app_assets.dart
│   │   │   ├── app_constants.dart
│   │   │   ├── app_links.dart
│   │   │   ├── app_spacing.dart
│   │   │   ├── app_strings.dart
│   │   │   └── constants.dart
│   │   ├── cubits/
│   │   │   ├── app_cubit.dart
│   │   │   └── app_state.dart
│   │   ├── di/
│   │   │   ├── core_di.dart
│   │   │   ├── features_di.dart
│   │   │   ├── services_di.dart
│   │   │   └── service_locator.dart
│   │   ├── error/
│   │   │   ├── error.dart
│   │   │   ├── failure.dart
│   │   │   └── failure_mapper.dart
│   │   ├── network/
│   │   │   ├── api_error_handler.dart
│   │   │   ├── network.dart
│   │   │   └── result.dart
│   │   ├── routing/
│   │   │   ├── app_navigator.dart
│   │   │   ├── app_router.dart
│   │   │   ├── app_routes.dart
│   │   │   └── app_transitions.dart
│   │   ├── services/
│   │   │   ├── analytics/
│   │   │   │   ├── analytics_service.dart
│   │   │   │   ├── dummy_analytics_service.dart
│   │   │   │   └── firebase_analytics_service.dart
│   │   │   ├── assets/
│   │   │   │   └── asset_loader.dart
│   │   │   ├── background_tasks/
│   │   │   │   ├── work_manager_service.dart
│   │   │   │   └── work_manager_service_impl.dart
│   │   │   ├── database/
│   │   │   │   ├── firestore_database_client.dart
│   │   │   │   └── nosql_database_client.dart
│   │   │   ├── device_info/
│   │   │   │   └── device_info_service.dart
│   │   │   ├── firebase/
│   │   │   │   └── firebase_options.dart
│   │   │   ├── haptic/
│   │   │   │   ├── haptic_service.dart
│   │   │   │   └── haptic_service_impl.dart
│   │   │   ├── local_storage/
│   │   │   │   ├── local_storage_service.dart
│   │   │   │   ├── local_storage_service_impl.dart
│   │   │   │   └── storage_keys.dart
│   │   │   ├── notification/
│   │   │   │   ├── models/
│   │   │   │   │   ├── notification_payload.dart
│   │   │   │   │   └── notification_request.dart
│   │   │   │   ├── notification_keys.dart
│   │   │   │   ├── notification_scheduler.dart
│   │   │   │   ├── notification_scheduler_impl.dart
│   │   │   │   ├── notification_service.dart
│   │   │   │   └── notification_service_impl.dart
│   │   │   ├── permissions/
│   │   │   │   └── app_permissions_manager.dart
│   │   │   ├── sharing/
│   │   │   │   ├── logic/
│   │   │   │   │   ├── share_service.dart
│   │   │   │   │   └── share_service_impl.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── share_config.dart
│   │   │   │   └── index.dart
│   │   │   ├── timer/
│   │   │   │   └── midnight_timer_service.dart
│   │   │   └── url_launcher/
│   │   │       ├── launch_url_service.dart
│   │   │       └── launch_url_service_impl.dart
│   │   ├── theme/
│   │   │   ├── colors/
│   │   │   │   ├── colors_dark.dart
│   │   │   │   └── colors_light.dart
│   │   │   ├── extensions/
│   │   │   │   ├── assets_extension.dart
│   │   │   │   └── color_extension.dart
│   │   │   ├── fonts/
│   │   │   │   ├── app_fonts_family.dart
│   │   │   │   └── app_text_styles.dart
│   │   │   └── app_theme.dart
│   │   └── utils/
│   │       ├── app_date_formatter.dart
│   │       ├── app_feedback.dart
│   │       ├── app_logger.dart
│   │       ├── app_validators.dart
│   │       ├── bloc_observer.dart
│   │       ├── context_extension.dart
│   │       ├── date_time_provider.dart
│   │       ├── responsive_extension.dart
│   │       ├── utils.dart
│   │       └── version_utils.dart
│   ├── features/
│   │   ├── app_date/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── app_date_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── app_date_repository.dart
│   │   │   ├── di/
│   │   │   │   └── app_date_di.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── app_date_cubit.dart
│   │   │       │   └── app_date_state.dart
│   │   │       └── widgets/
│   │   │           ├── hijri_adjustment_bottom_sheet.dart
│   │   │           └── hijri_and_gregorian_date_widget.dart
│   │   ├── app_update/
│   │   │   ├── data/
│   │   │   │   ├── constants/
│   │   │   │   │   └── remote_config_keys.dart
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── app_update_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── update_config_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── app_update_repository.dart
│   │   │   ├── presentation/
│   │   │   │   ├── cubits/
│   │   │   │   │   ├── app_update_cubit.dart
│   │   │   │   │   └── app_update_state.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── force_update_overlay.dart
│   │   │   │       ├── optional_update_banner.dart
│   │   │   │       ├── update_icon.dart
│   │   │   │       └── update_overlay.dart
│   │   ├── asma_ul_husna/
│   │   │   ├── asma_ul_husna.dart
│   │   │   ├── constants/
│   │   │   │   └── asma_keys.dart
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── asma_ul_husna_local_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── asma_ul_husna_model.dart
│   │   │   │   └── repos/
│   │   │   │       └── asma_ul_husna_repository.dart
│   │   │   ├── di/
│   │   │   │   └── asma_ul_husna_di.dart
│   │   │   ├── domain/
│   │   │   │   └── entities/
│   │   │   │       └── asma_ul_husna_entity.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── asma_ul_husna_cubit.dart
│   │   │       │   ├── asma_ul_husna_state.dart
│   │   │       │   ├── daily_asma_ul_husna_cubit.dart
│   │   │       │   └── daily_asma_ul_husna_state.dart
│   │   │       ├── pages/
│   │   │       │   └── asma_ul_husna_view.dart
│   │   │       ├── routes/
│   │   │       │   └── asma_ul_husna_routes.dart
│   │   │       └── widgets/
│   │   │           ├── asma_ul_husna_card.dart
│   │   │           ├── asma_ul_husna_share_card.dart
│   │   │           ├── daily_asma_ul_husna_card.dart
│   │   │           └── skeletonizer_loading_asma_ul_husna_view.dart
│   │   ├── azkar/
│   │   │   ├── data/
│   │   │   │   ├── constants/
│   │   │   │   │   └── azkar_constants.dart
│   │   │   │   ├── data_sources/
│   │   │   │   │   ├── azkar_local_data_source.dart
│   │   │   │   │   ├── azkar_local_data_source_impl.dart
│   │   │   │   │   ├── reminder_local_data_source.dart
│   │   │   │   │   └── reminder_local_data_source_impl.dart
│   │   │   │   ├── mappers/
│   │   │   │   │   └── reminder_mapper.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── category_model.dart
│   │   │   │   │   ├── reminder_model.dart
│   │   │   │   │   └── zikr_model.dart
│   │   │   │   └── repositories/
│   │   │   │       ├── azkar_repository_impl.dart
│   │   │   │       ├── reading_settings_repository_impl.dart
│   │   │   │       └── reminder_repository_impl.dart
│   │   │   ├── di/
│   │   │   │   └── azkar_di.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── category_entity.dart
│   │   │   │   │   ├── notification_template.dart
│   │   │   │   │   ├── reading_settings.dart
│   │   │   │   │   ├── reminder_entity.dart
│   │   │   │   │   ├── repeat_type.dart
│   │   │   │   │   ├── weekday.dart
│   │   │   │   │   └── zikr_entity.dart
│   │   │   │   ├── params/
│   │   │   │   │   ├── create_reminder_params.dart
│   │   │   │   │   └── update_reminder_params.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   ├── azkar_repository.dart
│   │   │   │   │   ├── reading_settings_repository.dart
│   │   │   │   │   └── reminder_repository.dart
│   │   │   │   ├── use_cases/
│   │   │   │   │   ├── create_reminder_use_case.dart
│   │   │   │   │   ├── delete_reminder_use_case.dart
│   │   │   │   │   ├── get_azkar_by_category_usecase.dart
│   │   │   │   │   ├── get_categories_usecase.dart
│   │   │   │   │   ├── get_reading_settings_usecase.dart
│   │   │   │   │   ├── get_reminders_use_case.dart
│   │   │   │   │   ├── reminder_scheduler_helper.dart
│   │   │   │   │   ├── reminder_use_cases.dart
│   │   │   │   │   ├── toggle_reminder_use_case.dart
│   │   │   │   │   ├── update_reading_settings_usecase.dart
│   │   │   │   │   └── update_reminder_use_case.dart
│   │   │   │   └── validators/
│   │   │   │       └── reminder_validator.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── azkar/
│   │   │       │   │   ├── azkar_cubit.dart
│   │   │       │   │   ├── azkar_state.dart
│   │   │       │   │   └── zikr_increment_result.dart
│   │   │       │   ├── categories/
│   │   │       │   │   ├── azkar_categories_cubit.dart
│   │   │       │   │   └── azkar_categories_state.dart
│   │   │       │   ├── reading_settings/
│   │   │       │   │   ├── reading_settings_cubit.dart
│   │   │       │   │   └── reading_settings_state.dart
│   │   │       │   └── reminder/
│   │   │       │       ├── reminder_cubit.dart
│   │   │       │       └── reminder_state.dart
│   │   │       ├── mappers/
│   │   │       │   └── category_icon_mapper.dart
│   │   │       ├── pages/
│   │   │       │   └── azkar_list_view.dart
│   │   │       ├── routes/
│   │   │       │   └── azkar_routes.dart
│   │   │       └── widgets/
│   │   │           ├── azkar_list_content.dart
│   │   │           ├── reading_settings/
│   │   │           │   ├── font_size_section.dart
│   │   │           │   └── reading_settings_bottom_sheet.dart
│   │   │           ├── reminder/
│   │   │           │   ├── reminder_dialog.dart
│   │   │           │   ├── reminder_empty_view.dart
│   │   │           │   ├── reminder_section.dart
│   │   │           │   ├── reminder_tile.dart
│   │   │           │   └── repeat_selector.dart
│   │   │           ├── share_card/
│   │   │           │   └── zikr_share_card.dart
│   │   │           ├── skeletonizer_azkar_list.dart
│   │   │           └── zikr_card/
│   │   │               ├── zikr_actions_row.dart
│   │   │               ├── zikr_content.dart
│   │   │               ├── zikr_counter.dart
│   │   │               └── zikr_item_card.dart
│   │   ├── daily_content/
│   │   │   ├── constants/
│   │   │   │   └── daily_content_keys.dart
│   │   │   ├── daily_content.dart
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── daily_content_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── daily_content_model.dart
│   │   │   │   ├── repos/
│   │   │   │   │   └── daily_content_repository.dart
│   │   │   │   └── services/
│   │   │   │       ├── daily_content_favorites_service.dart
│   │   │   │       └── daily_content_shuffle_service.dart
│   │   │   ├── di/
│   │   │   │   └── daily_content_di.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── daily_content_cubit.dart
│   │   │       │   ├── daily_content_state.dart
│   │   │       │   ├── daily_favorites_cubit.dart
│   │   │       │   └── daily_favorites_state.dart
│   │   │       ├── pages/
│   │   │       │   └── daily_content_favorites_view.dart
│   │   │       ├── routes/
│   │   │       │   └── daily_content_routes.dart
│   │   │       └── widgets/
│   │   │           ├── card/
│   │   │           │   ├── daily_content_card.dart
│   │   │           │   ├── daily_content_favorite_card.dart
│   │   │           │   ├── daily_hadith_card.dart
│   │   │           │   └── daily_sunnah_card.dart
│   │   │           └── share_card/
│   │   │               └── daily_content_share_card.dart
│   │   ├── developer_dashboard/
│   │   │   ├── constants/
│   │   │   │   └── dashboard_ui_constants.dart
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── dashboard_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── dashboard_feedback_model.dart
│   │   │   │   └── repos/
│   │   │   │       └── dashboard_repository.dart
│   │   │   ├── di/
│   │   │   │   └── dashboard_di.dart
│   │   │   ├── domain/
│   │   │   │   └── entities/
│   │   │   │       └── feedback_entity.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── dashboard_cubit.dart
│   │   │       │   └── dashboard_state.dart
│   │   │       ├── pages/
│   │   │       │   └── developer_dashboard_view.dart
│   │   │       ├── routes/
│   │   │       │   └── developer_dashboard_routes.dart
│   │   │       └── widgets/
│   │   │           ├── admin_feedback_actions.dart
│   │   │           ├── feedbacks_list_view.dart
│   │   │           ├── feedback_admin_card.dart
│   │   │           ├── feedback_content.dart
│   │   │           └── share_card/
│   │   │               └── feedback_share_card.dart
│   │   ├── feedback/
│   │   │   ├── constants/
│   │   │   │   └── feedback_keys.dart
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── feedback_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── feedback_model.dart
│   │   │   │   └── repos/
│   │   │   │       └── feedback_repository.dart
│   │   │   ├── di/
│   │   │   │   └── feedback_di.dart
│   │   │   ├── domain/
│   │   │   │   └── repos/
│   │   │   │       └── feedback_repository.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── feedback_cubit.dart
│   │   │       │   └── feedback_state.dart
│   │   │       ├── pages/
│   │   │       │   └── feedback_issue_view.dart
│   │   │       ├── routes/
│   │   │       │   └── feedback_routes.dart
│   │   │       └── widgets/
│   │   │           ├── feedback_form.dart
│   │   │           └── feedback_header.dart
│   │   ├── hadith_search/              (empty)
│   │   ├── home/
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   ├── features_local_data_source.dart
│   │   │   │   │   └── features_local_data_source_impl.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── category_item.dart
│   │   │   │   └── repos/
│   │   │   │       └── features_repository.dart
│   │   │   ├── di/
│   │   │   │   └── home_di.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── features_list_cubit.dart
│   │   │       │   └── features_list_state.dart
│   │   │       ├── pages/
│   │   │       │   └── home_view.dart
│   │   │       └── widgets/
│   │   │           ├── category/
│   │   │           │   ├── category_section_header.dart
│   │   │           │   ├── custom_badge.dart
│   │   │           │   └── feature_circular_card.dart
│   │   │           ├── circular_category_grid_section.dart
│   │   │           ├── sections/
│   │   │           │   ├── home_azkar_categories_section.dart
│   │   │           │   ├── home_daily_wisdom_section.dart
│   │   │           │   ├── home_features_category_section.dart
│   │   │           │   └── home_prayer_section.dart
│   │   │           └── skeleton/
│   │   │               ├── skeletonizer_home_daily_wisdom.dart
│   │   │               └── skeletonizer_home_prayer.dart
│   │   ├── location_manager/
│   │   │   ├── data/
│   │   │   │   ├── constants/
│   │   │   │   │   ├── arab_countries.dart
│   │   │   │   │   └── location_api_constants.dart
│   │   │   │   ├── data_sources/
│   │   │   │   │   ├── local/
│   │   │   │   │   │   ├── geolocator_wrapper.dart
│   │   │   │   │   │   └── location_local_data_source.dart
│   │   │   │   │   └── remote/
│   │   │   │   │       ├── location_api_client.dart
│   │   │   │   │       ├── location_api_client.g.dart
│   │   │   │   │       └── location_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── nominatim_response_model.dart
│   │   │   │   └── repos/
│   │   │   │       ├── location_repository.dart
│   │   │   │       └── location_repo_impl.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── location_name/
│   │   │       │   │   ├── location_name_cubit.dart
│   │   │       │   │   └── location_name_state.dart
│   │   │       │   ├── location_permission/
│   │   │       │   │   ├── location_cubit.dart
│   │   │       │   │   ├── location_permission_cubit.dart
│   │   │       │   │   └── location_state.dart
│   │   │       │   └── location_position/
│   │   │       │       ├── location_position_cubit.dart
│   │   │       │       └── location_position_state.dart
│   │   │       └── widgets/
│   │   │           ├── location_country_picker.dart
│   │   │           ├── location_guard.dart
│   │   │           └── location_loading_skeleton.dart
│   │   ├── main_layout/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── main_layout_view.dart
│   │   │       └── routes/
│   │   │           └── main_layout_routes.dart
│   │   ├── prayer/
│   │   │   ├── calculators/
│   │   │   │   ├── prayer_countdown_calculator.dart
│   │   │   │   └── prayer_time_status_calculator.dart
│   │   │   ├── constants/
│   │   │   │   ├── prayer_constants.dart
│   │   │   │   ├── prayer_name_provider.dart
│   │   │   │   ├── prayer_settings_keys.dart
│   │   │   │   └── prayer_settings_names.dart
│   │   │   ├── data/
│   │   │   │   ├── repos/
│   │   │   │   │   ├── prayer_repository.dart
│   │   │   │   └── services/
│   │   │   │       ├── prayer_state_service.dart
│   │   │   │       ├── prayer_status_service.dart
│   │   │   │       ├── prayer_times_service.dart
│   │   │   │       ├── religious_events_service.dart
│   │   │   │       └── user_settings_service.dart
│   │   │   ├── di/
│   │   │   │   └── prayer_di.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── coordinates_entity.dart
│   │   │   │   │   ├── prayer_calculation_settings_entity.dart
│   │   │   │   │   ├── prayer_info.dart
│   │   │   │   │   ├── prayer_state_result.dart
│   │   │   │   │   ├── prayer_times_entity.dart
│   │   │   │   │   ├── prayer_time_status.dart
│   │   │   │   │   ├── prayer_type.dart
│   │   │   │   │   ├── religious_event_entity.dart
│   │   │   │   │   ├── sunnah_entity.dart
│   │   │   │   │   ├── sunnah_times_entity.dart
│   │   │   │   │   └── user_prayer_times_settings_entity.dart
│   │   │   │   ├── enums/
│   │   │   │   │   └── religious_event.dart
│   │   │   │   ├── repos/
│   │   │   │   │   └── prayer_repository.dart
│   │   │   │   ├── services/
│   │   │   │   │   ├── prayer_calculation_service.dart
│   │   │   │   │   └── prayer_state_service.dart
│   │   │   │   └── use_cases/
│   │   │   │       ├── calculate_days_between_hijri_dates_use_case.dart
│   │   │   │       └── religious_event_use_cases.dart
│   │   │   ├── prayer.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── prayer_times_cubit.dart
│   │   │       │   └── prayer_times_state.dart
│   │   │       ├── models/
│   │   │       │   └── prayer_display_model.dart
│   │   │       ├── pages/
│   │   │       │   └── prayer_times_settings_view.dart
│   │   │       ├── routes/
│   │   │       │   └── prayer_routes.dart
│   │   │       └── widgets/
│   │   │           ├── header/
│   │   │           │   ├── city_country_widget.dart
│   │   │           │   ├── home_prayer_carousel.dart
│   │   │           │   ├── home_prayer_loaded.dart
│   │   │           │   └── widgets/
│   │   │           │       ├── prayer_countdown_carousel_card.dart
│   │   │           │       ├── prayer_status_carousel_card.dart
│   │   │           │       ├── prayer_status_details_dialog.dart
│   │   │           │       └── religious_event_carousel_card.dart
│   │   │           ├── prayer_card_content.dart
│   │   │           ├── prayer_settings/
│   │   │           │   ├── calculation_method_widget.dart
│   │   │           │   ├── madhab_widget.dart
│   │   │           │   ├── prayer_location_widget.dart
│   │   │           │   ├── settings_tile_widget.dart
│   │   │           │   └── settings_title.dart
│   │   │           ├── prayer_sunnah_bottom_sheet.dart
│   │   │           ├── prayer_timeline.dart
│   │   │           └── share_card/
│   │   │               └── sunnah_share_card.dart
│   │   ├── qibla/
│   │   │   ├── constants/
│   │   │   │   ├── qibla_data_constants.dart
│   │   │   │   └── qibla_ui_constants.dart
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── qibla_local_data_source.dart
│   │   │   │   ├── repos/
│   │   │   │   │   └── qibla_repository.dart
│   │   │   │   └── services/
│   │   │   │       └── qibla_service.dart
│   │   │   ├── di/
│   │   │   │   └── qibla_di.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── qibla_entities.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── qibla_repository.dart
│   │   │   │   ├── services/
│   │   │   │   │   ├── qibla_service.dart
│   │   │   │   │   └── qibla_service_impl.dart
│   │   │   │   └── use_cases/
│   │   │   │       ├── get_qibla_compass_stream_use_case.dart
│   │   │   │       └── get_qibla_direction_use_case.dart
│   │   │   ├── presentation/
│   │   │   │   ├── cubits/
│   │   │   │   │   ├── qibla_cubit.dart
│   │   │   │   │   └── qibla_state.dart
│   │   │   │   ├── pages/
│   │   │   │   │   └── qibla_view.dart
│   │   │   │   ├── routes/
│   │   │   │   │   └── qibla_routes.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── compass/
│   │   │   │       │   ├── compass_arrow.dart
│   │   │   │       │   ├── compass_background_painter.dart
│   │   │   │       │   ├── compass_kaaba_icon.dart
│   │   │   │       │   └── qibla_compass.dart
│   │   │   │       ├── hint/
│   │   │   │       │   └── qibla_hint_message.dart
│   │   │   │       ├── loaded/
│   │   │   │       │   ├── qibla_compass_stream_widget.dart
│   │   │   │       │   ├── qibla_content_layout_widget.dart
│   │   │   │       │   └── qibla_view_loaded_widget.dart
│   │   │   │       ├── map/
│   │   │   │       │   └── qibla_map_widget.dart
│   │   │   │       ├── qibla_help_dialog.dart
│   │   │   │       ├── qibla_mode_toggle.dart
│   │   │   │       ├── qibla_scaffold.dart
│   │   │   │       └── skeletonizer_qibla_widget.dart
│   │   │   └── qibla.dart
│   │   ├── quran/
│   │   │   ├── data/
│   │   │   │   └── repos/
│   │   │   │       └── quran_repo.dart
│   │   │   ├── di/
│   │   │   │   └── quran_di.dart
│   │   │   ├── domain/
│   │   │   │   ├── repos/
│   │   │   │   │   └── quran_repo.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── quran_cubit.dart
│   │   │       │   └── quran_state.dart
│   │   │       ├── pages/
│   │   │       │   └── quran_view.dart
│   │   │       ├── widgets/
│   │   │       │   ├── quran_error_widget.dart
│   │   │       │   ├── quran_loading_widget.dart
│   │   │       │   └── quran_success_widget.dart
│   │   │   └── quran.dart
│   │   ├── salat_ala_nabi/
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── reminder_local_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── reminder_settings.dart
│   │   │   │   ├── repos/
│   │   │   │   │   └── reminder_repo.dart
│   │   │   │   ├── salawat_constants.dart
│   │   │   │   └── services/
│   │   │   │       ├── salawat_background_executor.dart
│   │   │   │       ├── salawat_background_task_handler.dart
│   │   │   │       └── salawat_reminder_service.dart
│   │   │   ├── di/
│   │   │   │   └── salat_ala_nabi_di.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── reminder_settings_entity.dart
│   │   │   │   ├── repos/
│   │   │   │   │   ├── reminder_repo.dart
│   │   │   │   │   └── salawat_reminder_service.dart
│   │   │   │   └── use_cases/
│   │   │   │       ├── check_working_hours_use_case.dart
│   │   │   │       └── update_working_hours_use_case.dart
│   │   │   └── presentation/
│   │   │       ├── cubits/
│   │   │       │   ├── reminder_cubit.dart
│   │   │       │   └── reminder_state.dart
│   │   │       ├── pages/
│   │   │       │   └── salat_ala_nabi_view.dart
│   │   │       ├── routes/
│   │   │       │   └── salat_ala_nabi_routes.dart
│   │   │       └── widgets/
│   │   │           ├── custom_working_hour_option.dart
│   │   │           ├── interval_counter_widget.dart
│   │   │           ├── notification_and_enable_salat_alarm_toggle_widget.dart
│   │   │           ├── salat_ala_nabi_skeleton.dart
│   │   │           ├── salat_ala_nabi_view_content.dart
│   │   │           ├── toggle_title_and_switch_widget.dart
│   │   │           ├── working_hours_widget.dart
│   │   │           └── working_hour_option_item.dart
│   │   │   └── salat_ala_nabi.dart
│   │   ├── settings/
│   │   │   ├── di/
│   │   │   │   └── settings_di.dart
│   │   │   ├── presentation/
│   │   │   │   ├── cubits/
│   │   │   │   │   ├── settings_cubit.dart
│   │   │   │   │   └── settings_state.dart
│   │   │   │   └── pages/
│   │   │   │       └── settings_view.dart
│   │   │   └── settings.dart
│   │   ├── sharing/
│   │   │   └── presentation/
│   │   │       ├── app_info_share.dart
│   │   │       ├── combined_share_copy_button.dart
│   │   │       ├── helpers/
│   │   │       │   ├── app_clipboard.dart
│   │   │       │   ├── app_share.dart
│   │   │       │   └── widget_to_image_helper.dart
│   │   │       └── share_card_container.dart
│   │   ├── splash/
│   │   │   ├── presentation/
│   │   │   │   ├── cubits/
│   │   │   │   │   ├── splash_cubit.dart
│   │   │   │   │   └── splash_state.dart
│   │   │   │   ├── pages/
│   │   │   │   │   └── splash_view.dart
│   │   │   │   └── routes/
│   │   │   │       └── splash_routes.dart
│   │   │   └── splash.dart
│   │   └── teaching_prayer/
│   │       ├── constants/
│   │       │   └── teaching_prayer_keys.dart
│   │       ├── data/
│   │       │   ├── data_sources/
│   │       │   │   └── teaching_prayer_local_data_source.dart
│   │       │   ├── models/
│   │       │   │   └── teaching_prayer_model.dart
│   │       │   └── repos/
│   │       │       └── teaching_prayer_repo_impl.dart
│   │       ├── di/
│   │       │   └── teaching_prayer_di.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── teaching_prayer_entity.dart
│   │       │   ├── repos/
│   │       │   │   └── teaching_prayer_repository.dart
│   │       │   └── use_cases/
│   │       │       ├── parse_teaching_content_use_case.dart
│   │       │       └── parse_teaching_points_use_case.dart
│   │       ├── presentation/
│   │       │   ├── cubits/
│   │       │   │   ├── teaching_prayer_cubit.dart
│   │       │   │   └── teaching_prayer_state.dart
│   │       │   ├── pages/
│   │       │   │   └── teaching_prayer_view.dart
│   │       │   ├── routes/
│   │       │   │   └── teaching_prayer_routes.dart
│   │       │   └── widgets/
│   │       │       ├── teaching_prayer_success_widget.dart
│   │       │       ├── teaching_section_card.dart
│   │       │       └── teaching_topic_details_bottom_sheet.dart
│   │       └── teaching_prayer.dart
│   └── main.dart
└── test/
│   └── features/
│       └── azkar/
│           ├── data/
│           │   ├── constants/
│           │   │   └── azkar_constants_test.dart
│           │   ├── datasources/
│           │   │   └── reminder_local_data_source_impl_test.dart
│           │   ├── mappers/
│           │   │   └── reminder_mapper_test.dart
│           │   ├── models/
│           │   │   ├── category_model_test.dart
│           │   │   ├── reminder_model_adapter_test.dart
│           │   │   ├── reminder_model_test.dart
│           │   │   └── zikr_model_test.dart
│           │   └── repositories/
│           │       ├── azkar_repository_impl_test.dart
│           │       ├── reading_settings_repository_impl_test.dart
│           │       └── reminder_repository_impl_test.dart
│           ├── domain/
│           │   ├── entities/
│           │   │   ├── category_entity_test.dart
│           │   │   ├── notification_template_test.dart
│           │   │   ├── reading_settings_test.dart
│           │   │   ├── reminder_entity_test.dart
│           │   │   ├── repeat_type_test.dart
│           │   │   ├── weekday_test.dart
│           │   │   └── zikr_entity_test.dart
│           │   ├── params/
│           │   │   ├── create_reminder_params_test.dart
│           │   │   └── update_reminder_params_test.dart
│           │   ├── usecases/
│           │   │   ├── create_reminder_use_case_test.dart
│           │   │   ├── delete_reminder_use_case_test.dart
│           │   │   ├── get_azkar_by_category_usecase_test.dart
│           │   │   ├── get_categories_usecase_test.dart
│           │   │   ├── get_reading_settings_usecase_test.dart
│           │   │   ├── get_reminders_use_case_test.dart
│           │   │   ├── reminder_scheduler_helper_test.dart
│           │   │   ├── reminder_use_cases_test.dart
│           │   │   ├── toggle_reminder_use_case_test.dart
│           │   │   ├── update_reading_settings_usecase_test.dart
│           │   │   └── update_reminder_use_case_test.dart
│           │   └── validators/
│           │       └── reminder_validator_test.dart
│           ├── integration/
│           │   └── azkar_flow_test.dart
│           └── presentation/
│               ├── cubit/
│               │   ├── azkar/
│               │   │   ├── azkar_cubit_test.dart
│               │   │   └── azkar_state_test.dart
│               │   ├── categories/
│               │   │   └── azkar_categories_cubit_test.dart
│               │   ├── reading_settings/
│               │   │   └── reading_settings_cubit_test.dart
│               │   └── reminder/
│               │       ├── reminder_cubit_test.dart
│               │       └── reminder_state_test.dart
│               ├── utils/
│               │   └── category_icon_mapper_test.dart
│               └── widgets/
│                   ├── azkar_list_content_test.dart
│                   ├── reading_settings/
│                   │   └── font_size_section_test.dart
│                   ├── reminder/
│                   │   ├── reminder_empty_view_test.dart
│                   │   ├── reminder_tile_test.dart
│                   │   └── repeat_selector_test.dart
│                   ├── skeletonizer_azkar_list_test.dart
│                   └── zikr_card/
│                       ├── zikr_actions_row_test.dart
│                       ├── zikr_content_test.dart
│                       ├── zikr_counter_test.dart
│                       └── zikr_item_card_test.dart
```

---

## Architecture Overview

### Architecture Pattern: **Feature-First Clean Architecture with BLoC State Management**

This project adopts a hybrid **Clean Architecture** pattern that is layered **within each feature**, combined with **Feature-First** (feature-based) folder organization. This is a common and well-established pattern in the Flutter ecosystem.

### Main Layers Found in the Project

| Layer | Location | Description |
|---|---|---|
| **Core / Shared** | `lib/core/` | Shared infrastructure, reusable UI components, services, theme, routing, DI, network, error handling, and utilities used across all features. |
| **Feature** | `lib/features/{feature_name}/` | Each feature is a self-contained module following Clean Architecture internally. |
| **Data** | `{feature}/data/` | Data sources (local/remote), models (DTOs), mappers, repository implementations. |
| **Domain** | `{feature}/domain/` | Entities (pure Dart objects), repository interfaces (contracts), use cases. |
| **Presentation** | `{feature}/presentation/` | Cubits (state management), pages (screens), widgets (UI components). |
| **Dependency Injection** | `{feature}/di/` | Feature-specific DI module (GetIt service locator wiring). |
| **Root** | `lib/main.dart` | App entry point. |

### Responsibility of Each Major Folder

#### `lib/core/` — **Shared Core Infrastructure**

**Responsibility:** Provides the foundational building blocks used by every feature. This includes theming, routing, error handling, networking, common reusable widgets, services abstractions, dependency injection setup, and utility extensions.

| Subfolder | Responsibility |
|---|---|
| `bootstrap/` | App initialization (Firebase, error handlers, lifecycle management) |
| `common/` | Reusable UI components: buttons, cards, decorations, favorites widgets, layout helpers, overlays (bottom sheets, dialogs, toasts), slivers, and generic widgets |
| `constants/` | App-wide constants: API endpoints, asset paths, spacing, strings, links |
| `cubits/` | Base/shared cubits and app-level states |
| `di/` | Dependency injection wiring (service locator registration) |
| `error/` | Error and failure abstraction, failure-to-user-message mapping |
| `network/` | Network layer abstractions: API error handling, generic Result type |
| `routing/` | Navigation: router configuration, routes, navigator helpers, page transitions |
| `services/` | Abstracted platform/infrastructure services: analytics, asset loading, background tasks, databases, device info, haptics, local storage, notifications, permissions, sharing, timer, URL launcher |
| `theme/` | App theme configuration: light/dark colors, fonts, text styles, asset/color extensions |
| `utils/` | Utility classes: date formatting, feedback helpers, logging, validation, platform extensions, version utilities |

#### `lib/features/` — **Feature Modules**

**Responsibility:** Each feature is encapsulated in its own folder with a consistent internal structure. This modular approach keeps the codebase scalable, testable, and maintainable.

Each feature typically contains:

| Subfolder | Responsibility |
|---|---|
| `data/` | Concrete implementations: local/remote data sources, DTO models, mappers, repository implementations |
| `domain/` | Business logic layer: pure Dart entities, repository contracts (interfaces), use cases |
| `presentation/` | UI layer: cubits (state management), pages/screens, widgets |
| `di/` | Feature-specific dependency registration |
| `constants/` | Feature-specific constants |
| `calculators/` | Feature-specific calculation logic (prayer feature) |
| `(feature_name).dart` | Barrel export file for the feature |

**Dependency Flow:**
```
Presentation → Cubits (State) ← Domain (Use Cases → Repository Interface)
                                                              ↓
                                                      Data (Repository Impl → Data Sources)
```

The dependency rule is strictly inward: **Presentation** depends on **Domain**, **Data** implements **Domain** interfaces. **Domain** has no dependencies on other layers. **Core** is shared across all features.

#### `test/` — **Tests**

**Responsibility:** Currently contains a comprehensive test suite exclusively for the `azkar` feature, mirroring its internal structure (data, domain, presentation). Includes unit tests and integration tests.

#### `assets/` — **Static Resources**

**Responsibility:** Houses all app assets: JSON data files (Azkar categories, Asma Ul Husna, daily content, prayer status, religious events, teaching prayer), fonts (Amiri Quran, Cairo), audio files, native splash/icon PNGs, and SVG assets.

#### `android/` & `ios/` & `web/` — **Platform-Specific Code**

**Responsibility:** Platform entry points and configurations. Includes Android Fastlane deployment setup, iOS Runner configuration, and web PWA manifest/icons with Vercel deployment config.

---

## Feature Summary

### `app_date` — Hijri & Gregorian Date Display

**Contains:**
- Repository and model for date data
- Cubit for state management (hijri date with adjustment)
- Widgets for displaying combined Hijri/Gregorian dates and adjustment bottom sheet

**Files:** `app_date_model.dart`, `app_date_repository.dart`, `app_date_cubit.dart`, `app_date_state.dart`, `hijri_adjustment_bottom_sheet.dart`, `hijri_and_gregorian_date_widget.dart`, `app_date_di.dart`

---

### `app_update` — In-App Update Manager

**Contains:**
- Remote configuration data source for update config
- Repository and model for update configuration
- Cubit managing update state (force/optional)
- Widgets: force update overlay, optional update banner, update icon

**Files:** `remote_config_keys.dart`, `app_update_data_source.dart`, `update_config_model.dart`, `app_update_repository.dart`, `app_update_cubit.dart`, `app_update_state.dart`, `force_update_overlay.dart`, `optional_update_banner.dart`, `update_icon.dart`, `update_overlay.dart`

---

### `asma_ul_husna` — 99 Names of Allah

**Contains:**
- Local JSON data source for names
- Entity and model for Asma Ul Husna
- Cubits for list display and daily name
- View page with card-based UI
- Share card widget for sharing names

**Files:** `asma_ul_husna.dart`, `asma_keys.dart`, `asma_ul_husna_local_data_source.dart`, `asma_ul_husna_model.dart`, `asma_ul_husna_repository.dart`, `asma_ul_husna_entity.dart`, `asma_ul_husna_cubit.dart`, `asma_ul_husna_state.dart`, `daily_asma_ul_husna_cubit.dart`, `daily_asma_ul_husna_state.dart`, `asma_ul_husna_view.dart`, `asma_ul_husna_routes.dart`, `asma_ul_husna_card.dart`, `asma_ul_husna_share_card.dart`, `daily_asma_ul_husna_card.dart`, `skeletonizer_loading_asma_ul_husna_view.dart`, `asma_ul_husna_di.dart`

---

### `azkar` — Islamic Remembrances (Azkar)

**Contains:**
- **Data Layer:** Local JSON data sources for Azkar categories and zikr content, local database/data source for reminders, models (category, zikr, reminder), mappers, repository implementations
- **Domain Layer:** Entities (category, zikr, reminder, repeat type, weekday, reading settings, notification template), repository contracts, use cases (CRUD reminders, get categories/azkar by category, reading settings), validators, params
- **Presentation Layer:** Cubits (azkar list, categories, reading settings, reminders), main list view page, widgets (zikr cards with counter/actions, reminder management UI, reading settings bottom sheet, share card, skeleton loaders)

**Files:** ~40+ files across all Clean Architecture layers. Heavily tested with comprehensive unit and widget tests.

---

### `daily_content` — Daily Wisdom (Hadith & Sunnah)

**Contains:**
- Local JSON data source for daily content
- Models and repository for daily content
- Favorites service and shuffle service
- Cubits for content display and favorites management
- Pages for favorites view
- Widgets: daily content cards (hadith, sunnah), favorite cards, share card

**Files:** `daily_content.dart`, `daily_content_keys.dart`, `daily_content_datasource.dart`, `daily_content_model.dart`, `daily_content_repository.dart`, `daily_content_favorites_service.dart`, `daily_content_shuffle_service.dart`, `daily_content_cubit.dart`, `daily_content_state.dart`, `daily_favorites_cubit.dart`, `daily_favorites_state.dart`, `daily_content_favorites_view.dart`, `daily_content_routes.dart`, `daily_content_card.dart`, `daily_content_favorite_card.dart`, `daily_hadith_card.dart`, `daily_sunnah_card.dart`, `daily_content_share_card.dart`, `daily_content_di.dart`

---

### `developer_dashboard` — Admin/Developer Dashboard

**Contains:**
- Remote data source for dashboard data
- Model and repository for user feedback
- Feedback entity
- Cubit for dashboard state
- Admin feedback management page with actions (approve/reject), feedback list, share card

**Files:** `dashboard_ui_constants.dart`, `dashboard_remote_data_source.dart`, `dashboard_feedback_model.dart`, `dashboard_repository.dart`, `feedback_entity.dart`, `dashboard_cubit.dart`, `dashboard_state.dart`, `developer_dashboard_view.dart`, `developer_dashboard_routes.dart`, `admin_feedback_actions.dart`, `feedbacks_list_view.dart`, `feedback_admin_card.dart`, `feedback_content.dart`, `feedback_share_card.dart`, `dashboard_di.dart`

---

### `feedback` — User Feedback/Issue Reporting

**Contains:**
- Remote data source for submitting feedback
- Model and repository for feedback data
- Domain repository contract
- Cubit for feedback submission state
- Feedback form page with header widget

**Files:** `feedback_keys.dart`, `feedback_remote_data_source.dart`, `feedback_model.dart`, `feedback_repository.dart`, `feedback_repository.dart` (domain), `feedback_cubit.dart`, `feedback_state.dart`, `feedback_issue_view.dart`, `feedback_routes.dart`, `feedback_form.dart`, `feedback_header.dart`, `feedback_di.dart`

---

### `hadith_search` — Hadith Search *(Empty)*

**Contains:** Empty folder — placeholder for future implementation.

---

### `home` — App Home Screen

**Contains:**
- Local data source for feature categories
- Category item model and features repository
- Cubit for feature list state
- Home page with multiple sections: Azkar categories, daily wisdom, features category grid, prayer section
- Skeleton loading widgets

**Files:** `features_local_data_source.dart`, `features_local_data_source_impl.dart`, `category_item.dart`, `features_repository.dart`, `features_list_cubit.dart`, `features_list_state.dart`, `home_view.dart`, `category_section_header.dart`, `custom_badge.dart`, `feature_circular_card.dart`, `circular_category_grid_section.dart`, `home_azkar_categories_section.dart`, `home_daily_wisdom_section.dart`, `home_features_category_section.dart`, `home_prayer_section.dart`, `skeletonizer_home_daily_wisdom.dart`, `skeletonizer_home_prayer.dart`, `home_di.dart`

---

### `location_manager` — Location Services

**Contains:**
- **Data Layer:** Local (Geolocator wrapper, local data source) and remote (Nominatim API client, remote data source) data sources, constants (API endpoints, Arab countries list), models (Nominatim response), repository and its implementation
- **Presentation Layer:** Cubits for location name, permission, and position management; widgets: country picker, location guard, loading skeleton

**Files:** `arab_countries.dart`, `location_api_constants.dart`, `geolocator_wrapper.dart`, `location_local_data_source.dart`, `location_api_client.dart`, `location_api_client.g.dart`, `location_remote_data_source.dart`, `nominatim_response_model.dart`, `location_repository.dart`, `location_repo_impl.dart`, `location_name_cubit.dart`, `location_name_state.dart`, `location_cubit.dart`, `location_permission_cubit.dart`, `location_state.dart`, `location_position_cubit.dart`, `location_position_state.dart`, `location_country_picker.dart`, `location_guard.dart`, `location_loading_skeleton.dart`

---

### `main_layout` — App Shell / Main Layout

**Contains:**
- Main layout view (the app shell/navigation scaffold)
- Routing configuration for the main layout

**Files:** `main_layout_view.dart`, `main_layout_routes.dart`

---

### `prayer` — Prayer Times & Islamic Events

**Contains:**
- **Calculators:** Countdown calculator, prayer time status calculator
- **Constants:** Prayer names, settings keys/names, constants
- **Data Layer:** Repository implementation, services (prayer state, status, times, religious events, user settings)
- **Domain Layer:** Entities (coordinates, calculation settings, prayer info/state/times/status/types, religious events, sunnah), enums (religious event), repository contracts, services (calculation, state), use cases
- **Presentation Layer:** Cubit for prayer times, display models, settings page, widgets: header (city/country, carousels, countdown/status/event cards), settings widgets (calculation method, madhab, location), sunnah bottom sheet, prayer timeline, share card

**Files:** ~45+ files across all layers. One of the most complex features.

---

### `qibla` — Qibla Compass & Direction

**Contains:**
- **Data Layer:** Local data source for Qibla data, repository
- **Domain Layer:** Entities (coordinates, direction), repository contracts, services (calculation and implementation), use cases (compass stream, direction calculation)
- **Presentation Layer:** Cubit for Qibla state, main Qibla view, widgets: compass (arrow, background painter, Kaaba icon), hint message, loaded views (compass stream, content layout), map widget, help dialog, mode toggle, scaffold, skeleton loader

**Files:** `qibla.dart`, `qibla_data_constants.dart`, `qibla_ui_constants.dart`, `qibla_local_data_source.dart`, `qibla_repository.dart` (data), `qibla_service.dart` (data), `qibla_entities.dart`, `qibla_repository.dart` (domain), `qibla_service.dart` (domain), `qibla_service_impl.dart`, `get_qibla_compass_stream_use_case.dart`, `get_qibla_direction_use_case.dart`, `qibla_cubit.dart`, `qibla_state.dart`, `qibla_view.dart`, `qibla_routes.dart`, plus ~15 widget files, `qibla_di.dart`

---

### `quran` — Quran Reader

**Contains:**
- Data repository (minimal — likely uses external API or asset-based loading)
- Domain repository contract
- Cubit for Quran display state
- Quran view page with loading, error, and success states

**Files:** `quran.dart`, `quran_repo.dart` (data), `quran_repo.dart` (domain), `quran_cubit.dart`, `quran_state.dart`, `quran_view.dart`, `quran_error_widget.dart`, `quran_loading_widget.dart`, `quran_success_widget.dart`, `quran_di.dart`

---

### `salat_ala_nabi` — Salawat (Prayers upon the Prophet)

**Contains:**
- **Data Layer:** Local data source for reminder settings, models (reminder settings), repository, constants, services (background executor, background task handler, reminder service)
- **Domain Layer:** Entities (reminder settings), repository contracts, use cases (check/update working hours)
- **Presentation Layer:** Cubit for reminder settings state, main view page, widgets: working hours configuration, interval counter, notification toggle, skeleton loader

**Files:** `salat_ala_nabi.dart`, `reminder_local_data_source.dart`, `reminder_settings.dart`, `reminder_repo.dart` (data), `salawat_constants.dart`, `salawat_background_executor.dart`, `salawat_background_task_handler.dart`, `salawat_reminder_service.dart`, `reminder_settings_entity.dart`, `reminder_repo.dart` (domain), `salawat_reminder_service.dart` (domain), `check_working_hours_use_case.dart`, `update_working_hours_use_case.dart`, `reminder_cubit.dart`, `reminder_state.dart`, `salat_ala_nabi_view.dart`, `salat_ala_nabi_routes.dart`, plus ~7 widget files, `salat_ala_nabi_di.dart`

---

### `settings` — App Settings

**Contains:**
- DI module for settings
- Cubit for settings state management
- Settings view page

**Files:** `settings.dart`, `settings_cubit.dart`, `settings_state.dart`, `settings_view.dart`, `settings_di.dart`

---

### `sharing` — Share & Copy Functionality

**Contains:**
- App info share helper
- Combined share + copy button widget
- Helpers: clipboard, share, widget-to-image conversion
- Share card container

**Files:** `app_info_share.dart`, `combined_share_copy_button.dart`, `app_clipboard.dart`, `app_share.dart`, `widget_to_image_helper.dart`, `share_card_container.dart`

---

### `splash` — Splash Screen

**Contains:**
- Cubit for splash initialization state
- Splash view page
- Routes for splash navigation

**Files:** `splash.dart`, `splash_cubit.dart`, `splash_state.dart`, `splash_view.dart`, `splash_routes.dart`

---

### `teaching_prayer` — How to Pray (Teaching Content)

**Contains:**
- Local JSON data source for teaching content
- Model and entity for teaching prayer content
- Repository and implementation
- Use cases for parsing teaching content and teaching points
- Cubit for teaching prayer state
- Main view page with widgets: success content, section cards, topic details bottom sheet

**Files:** `teaching_prayer.dart`, `teaching_prayer_keys.dart`, `teaching_prayer_local_data_source.dart`, `teaching_prayer_model.dart`, `teaching_prayer_repo_impl.dart`, `teaching_prayer_entity.dart`, `teaching_prayer_repository.dart`, `parse_teaching_content_use_case.dart`, `parse_teaching_points_use_case.dart`, `teaching_prayer_cubit.dart`, `teaching_prayer_state.dart`, `teaching_prayer_view.dart`, `teaching_prayer_routes.dart`, `teaching_prayer_success_widget.dart`, `teaching_section_card.dart`, `teaching_topic_details_bottom_sheet.dart`, `teaching_prayer_di.dart`
```

**File location:** `PROJECT_STRUCTURE.md` is in the project root: `D:\flutter\flutter_Projects\muslim_app\PROJECT_STRUCTURE.md`

---

## Summary

### What was documented

The entire Flutter project structure — all folders, subfolders, and files — was scanned and documented in a single comprehensive Markdown file. The documentation includes:

1. **Complete Directory Tree** — Full hierarchical tree of the project showing every file and folder (excluding generated files like `.dart_tool`, `build`, and IDE metadata).
2. **Architecture Overview** — Description of the **Feature-First Clean Architecture + BLoC** pattern used, including a breakdown of each major folder's responsibility and the dependency flow.
3. **Feature Summary** — For each of the 19 feature folders (plus the shared `sharing` feature), a short summary of what it contains and a list of its key files.

### Architecture Observations

1. **Consistent Clean Architecture per Feature** — The project enforces a strict separation of concerns within each feature: `data/` (implementation), `domain/` (contracts & business logic), `presentation/` (UI). This is a robust, scalable pattern.

2. **Strong Core Infrastructure** — The `lib/core/` layer is well-organized with reusable UI components (buttons, dialogs, toasts, cards, overlays), abstracted services (notification, local storage, sharing, analytics, permissions, etc.), theme system, routing, error handling, and DI wiring.

3. **BLoC State Management** — The project consistently uses the `flutter_bloc` / `cubit` pattern across all features, with clear separation between cubits and states.

4. **Dependency Injection via GetIt** — A service locator pattern (`GetIt`) is used for DI, with separate DI modules for core, services, and each feature.

5. **Comprehensive Azkar Feature** — The `azkar` feature is the most complete and well-tested module, with a full Clean Architecture setup, ~40+ source files, and a comprehensive test suite (40+ test files across data, domain, and presentation layers).

6. **Empty Placeholder** — `hadith_search` exists as an empty directory — a placeholder for future development.

7. **Platform-Ready** — The project includes full platform configurations for Android (Fastlane deployment), iOS, and Web (Vercel + PWA), plus Shorebird for code-pushing capabilities.

<｜｜DSML｜｜tool_calls>
<｜｜DSML｜｜invoke name="suggest_followups">
<｜｜DSML｜｜parameter name="followups" string="false">[{"label": "Review architecture", "prompt": "Review the architecture and suggest improvements or refactoring opportunities based on the PROJECT_STRUCTURE.md documentation"}, {"label": "Feature roadmap", "prompt": "Based on the documented features, suggest a development roadmap for the empty hadith_search feature"}, {"label": "Dependency graph", "prompt": "Analyze the dependency flow between features and core, and generate a dependency graph diagram"}]
