//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:tandoor_api/src/date_serializer.dart';
import 'package:tandoor_api/src/model/date.dart';

import 'package:tandoor_api/src/model/access_token.dart';
import 'package:tandoor_api/src/model/ai_log.dart';
import 'package:tandoor_api/src/model/ai_provider.dart';
import 'package:tandoor_api/src/model/auth_token.dart';
import 'package:tandoor_api/src/model/auto_meal_plan.dart';
import 'package:tandoor_api/src/model/automation.dart';
import 'package:tandoor_api/src/model/automation_type_enum.dart';
import 'package:tandoor_api/src/model/booking_type_enum.dart';
import 'package:tandoor_api/src/model/bookmarklet_import.dart';
import 'package:tandoor_api/src/model/bookmarklet_import_list.dart';
import 'package:tandoor_api/src/model/connector_config.dart';
import 'package:tandoor_api/src/model/connector_config_type_enum.dart';
import 'package:tandoor_api/src/model/connector_config_url.dart';
import 'package:tandoor_api/src/model/cook_log.dart';
import 'package:tandoor_api/src/model/custom_filter.dart';
import 'package:tandoor_api/src/model/default_page_enum.dart';
import 'package:tandoor_api/src/model/delete_enum.dart';
import 'package:tandoor_api/src/model/export_log.dart';
import 'package:tandoor_api/src/model/export_request.dart';
import 'package:tandoor_api/src/model/fdc_query.dart';
import 'package:tandoor_api/src/model/fdc_query_foods.dart';
import 'package:tandoor_api/src/model/food.dart';
import 'package:tandoor_api/src/model/food_batch_update.dart';
import 'package:tandoor_api/src/model/food_inherit_field.dart';
import 'package:tandoor_api/src/model/food_shopping.dart';
import 'package:tandoor_api/src/model/food_shopping_update.dart';
import 'package:tandoor_api/src/model/food_simple.dart';
import 'package:tandoor_api/src/model/generic_model_reference.dart';
import 'package:tandoor_api/src/model/group.dart';
import 'package:tandoor_api/src/model/household.dart';
import 'package:tandoor_api/src/model/import_log.dart';
import 'package:tandoor_api/src/model/import_open_data.dart';
import 'package:tandoor_api/src/model/import_open_data_meta_data.dart';
import 'package:tandoor_api/src/model/import_open_data_response.dart';
import 'package:tandoor_api/src/model/import_open_data_response_detail.dart';
import 'package:tandoor_api/src/model/import_open_data_version_meta_data.dart';
import 'package:tandoor_api/src/model/ingredient.dart';
import 'package:tandoor_api/src/model/ingredient_parser_request.dart';
import 'package:tandoor_api/src/model/ingredient_parser_response.dart';
import 'package:tandoor_api/src/model/ingredient_simple.dart';
import 'package:tandoor_api/src/model/inventory_entry.dart';
import 'package:tandoor_api/src/model/inventory_location.dart';
import 'package:tandoor_api/src/model/inventory_log.dart';
import 'package:tandoor_api/src/model/invite_link.dart';
import 'package:tandoor_api/src/model/invite_link_email.dart';
import 'package:tandoor_api/src/model/keyword.dart';
import 'package:tandoor_api/src/model/keyword_label.dart';
import 'package:tandoor_api/src/model/keyword_mode_enum.dart';
import 'package:tandoor_api/src/model/localization.dart';
import 'package:tandoor_api/src/model/meal_plan.dart';
import 'package:tandoor_api/src/model/meal_type.dart';
import 'package:tandoor_api/src/model/method_enum.dart';
import 'package:tandoor_api/src/model/model_sync.dart';
import 'package:tandoor_api/src/model/nutrition_information.dart';
import 'package:tandoor_api/src/model/paginated_ai_log_list.dart';
import 'package:tandoor_api/src/model/paginated_ai_provider_list.dart';
import 'package:tandoor_api/src/model/paginated_automation_list.dart';
import 'package:tandoor_api/src/model/paginated_bookmarklet_import_list_list.dart';
import 'package:tandoor_api/src/model/paginated_connector_config_list.dart';
import 'package:tandoor_api/src/model/paginated_cook_log_list.dart';
import 'package:tandoor_api/src/model/paginated_custom_filter_list.dart';
import 'package:tandoor_api/src/model/paginated_export_log_list.dart';
import 'package:tandoor_api/src/model/paginated_food_list.dart';
import 'package:tandoor_api/src/model/paginated_generic_model_reference_list.dart';
import 'package:tandoor_api/src/model/paginated_household_list.dart';
import 'package:tandoor_api/src/model/paginated_import_log_list.dart';
import 'package:tandoor_api/src/model/paginated_ingredient_list.dart';
import 'package:tandoor_api/src/model/paginated_inventory_entry_list.dart';
import 'package:tandoor_api/src/model/paginated_inventory_location_list.dart';
import 'package:tandoor_api/src/model/paginated_inventory_log_list.dart';
import 'package:tandoor_api/src/model/paginated_invite_link_list.dart';
import 'package:tandoor_api/src/model/paginated_keyword_list.dart';
import 'package:tandoor_api/src/model/paginated_meal_plan_list.dart';
import 'package:tandoor_api/src/model/paginated_meal_type_list.dart';
import 'package:tandoor_api/src/model/paginated_property_list.dart';
import 'package:tandoor_api/src/model/paginated_property_type_list.dart';
import 'package:tandoor_api/src/model/paginated_recipe_book_entry_list.dart';
import 'package:tandoor_api/src/model/paginated_recipe_book_list.dart';
import 'package:tandoor_api/src/model/paginated_recipe_import_list.dart';
import 'package:tandoor_api/src/model/paginated_recipe_overview_list.dart';
import 'package:tandoor_api/src/model/paginated_shopping_list_entry_list.dart';
import 'package:tandoor_api/src/model/paginated_shopping_list_list.dart';
import 'package:tandoor_api/src/model/paginated_shopping_list_recipe_list.dart';
import 'package:tandoor_api/src/model/paginated_space_list.dart';
import 'package:tandoor_api/src/model/paginated_step_list.dart';
import 'package:tandoor_api/src/model/paginated_storage_list.dart';
import 'package:tandoor_api/src/model/paginated_supermarket_category_list.dart';
import 'package:tandoor_api/src/model/paginated_supermarket_category_relation_list.dart';
import 'package:tandoor_api/src/model/paginated_supermarket_list.dart';
import 'package:tandoor_api/src/model/paginated_sync_list.dart';
import 'package:tandoor_api/src/model/paginated_sync_log_list.dart';
import 'package:tandoor_api/src/model/paginated_unit_conversion_list.dart';
import 'package:tandoor_api/src/model/paginated_unit_list.dart';
import 'package:tandoor_api/src/model/paginated_user_file_list.dart';
import 'package:tandoor_api/src/model/paginated_user_space_list.dart';
import 'package:tandoor_api/src/model/paginated_view_log_list.dart';
import 'package:tandoor_api/src/model/patched_access_token.dart';
import 'package:tandoor_api/src/model/patched_ai_provider.dart';
import 'package:tandoor_api/src/model/patched_automation.dart';
import 'package:tandoor_api/src/model/patched_bookmarklet_import.dart';
import 'package:tandoor_api/src/model/patched_connector_config.dart';
import 'package:tandoor_api/src/model/patched_cook_log.dart';
import 'package:tandoor_api/src/model/patched_custom_filter.dart';
import 'package:tandoor_api/src/model/patched_export_log.dart';
import 'package:tandoor_api/src/model/patched_food.dart';
import 'package:tandoor_api/src/model/patched_household.dart';
import 'package:tandoor_api/src/model/patched_import_log.dart';
import 'package:tandoor_api/src/model/patched_ingredient.dart';
import 'package:tandoor_api/src/model/patched_inventory_entry.dart';
import 'package:tandoor_api/src/model/patched_inventory_location.dart';
import 'package:tandoor_api/src/model/patched_invite_link.dart';
import 'package:tandoor_api/src/model/patched_keyword.dart';
import 'package:tandoor_api/src/model/patched_meal_plan.dart';
import 'package:tandoor_api/src/model/patched_meal_type.dart';
import 'package:tandoor_api/src/model/patched_property.dart';
import 'package:tandoor_api/src/model/patched_property_type.dart';
import 'package:tandoor_api/src/model/patched_recipe.dart';
import 'package:tandoor_api/src/model/patched_recipe_book.dart';
import 'package:tandoor_api/src/model/patched_recipe_book_entry.dart';
import 'package:tandoor_api/src/model/patched_recipe_import.dart';
import 'package:tandoor_api/src/model/patched_search_preference.dart';
import 'package:tandoor_api/src/model/patched_shopping_list.dart';
import 'package:tandoor_api/src/model/patched_shopping_list_entry.dart';
import 'package:tandoor_api/src/model/patched_shopping_list_recipe.dart';
import 'package:tandoor_api/src/model/patched_space.dart';
import 'package:tandoor_api/src/model/patched_step.dart';
import 'package:tandoor_api/src/model/patched_storage.dart';
import 'package:tandoor_api/src/model/patched_supermarket.dart';
import 'package:tandoor_api/src/model/patched_supermarket_category.dart';
import 'package:tandoor_api/src/model/patched_supermarket_category_relation.dart';
import 'package:tandoor_api/src/model/patched_sync.dart';
import 'package:tandoor_api/src/model/patched_unit.dart';
import 'package:tandoor_api/src/model/patched_unit_conversion.dart';
import 'package:tandoor_api/src/model/patched_user.dart';
import 'package:tandoor_api/src/model/patched_user_preference.dart';
import 'package:tandoor_api/src/model/patched_user_space.dart';
import 'package:tandoor_api/src/model/patched_view_log.dart';
import 'package:tandoor_api/src/model/property.dart';
import 'package:tandoor_api/src/model/property_type.dart';
import 'package:tandoor_api/src/model/recipe.dart';
import 'package:tandoor_api/src/model/recipe_batch_update.dart';
import 'package:tandoor_api/src/model/recipe_book.dart';
import 'package:tandoor_api/src/model/recipe_book_entry.dart';
import 'package:tandoor_api/src/model/recipe_flat.dart';
import 'package:tandoor_api/src/model/recipe_from_source.dart';
import 'package:tandoor_api/src/model/recipe_from_source_response.dart';
import 'package:tandoor_api/src/model/recipe_image.dart';
import 'package:tandoor_api/src/model/recipe_import.dart';
import 'package:tandoor_api/src/model/recipe_overview.dart';
import 'package:tandoor_api/src/model/recipe_shopping_update.dart';
import 'package:tandoor_api/src/model/recipe_simple.dart';
import 'package:tandoor_api/src/model/search_enum.dart';
import 'package:tandoor_api/src/model/search_fields.dart';
import 'package:tandoor_api/src/model/search_preference.dart';
import 'package:tandoor_api/src/model/server_settings.dart';
import 'package:tandoor_api/src/model/share_link.dart';
import 'package:tandoor_api/src/model/shopping_list.dart';
import 'package:tandoor_api/src/model/shopping_list_entry.dart';
import 'package:tandoor_api/src/model/shopping_list_entry_bulk.dart';
import 'package:tandoor_api/src/model/shopping_list_entry_bulk_create.dart';
import 'package:tandoor_api/src/model/shopping_list_entry_simple_create.dart';
import 'package:tandoor_api/src/model/shopping_list_recipe.dart';
import 'package:tandoor_api/src/model/source_import_duplicate.dart';
import 'package:tandoor_api/src/model/source_import_food.dart';
import 'package:tandoor_api/src/model/source_import_ingredient.dart';
import 'package:tandoor_api/src/model/source_import_keyword.dart';
import 'package:tandoor_api/src/model/source_import_property.dart';
import 'package:tandoor_api/src/model/source_import_property_type.dart';
import 'package:tandoor_api/src/model/source_import_recipe.dart';
import 'package:tandoor_api/src/model/source_import_step.dart';
import 'package:tandoor_api/src/model/source_import_unit.dart';
import 'package:tandoor_api/src/model/space.dart';
import 'package:tandoor_api/src/model/space_nav_text_color_enum.dart';
import 'package:tandoor_api/src/model/space_theme_enum.dart';
import 'package:tandoor_api/src/model/step.dart';
import 'package:tandoor_api/src/model/storage.dart';
import 'package:tandoor_api/src/model/supermarket.dart';
import 'package:tandoor_api/src/model/supermarket_category.dart';
import 'package:tandoor_api/src/model/supermarket_category_relation.dart';
import 'package:tandoor_api/src/model/sync_log.dart';
import 'package:tandoor_api/src/model/theme_enum.dart';
import 'package:tandoor_api/src/model/unit.dart';
import 'package:tandoor_api/src/model/unit_conversion.dart';
import 'package:tandoor_api/src/model/user.dart';
import 'package:tandoor_api/src/model/user_file.dart';
import 'package:tandoor_api/src/model/user_file_view.dart';
import 'package:tandoor_api/src/model/user_preference.dart';
import 'package:tandoor_api/src/model/user_preference_nav_text_color_enum.dart';
import 'package:tandoor_api/src/model/user_space.dart';
import 'package:tandoor_api/src/model/user_space_batch_update.dart';
import 'package:tandoor_api/src/model/view_log.dart';

part 'serializers.g.dart';

@SerializersFor([
  AccessToken,
  AiLog,
  AiProvider,
  AuthToken,
  AutoMealPlan,
  Automation,
  AutomationTypeEnum,
  BookingTypeEnum,
  BookmarkletImport,
  BookmarkletImportList,
  ConnectorConfig,
  ConnectorConfigTypeEnum,
  ConnectorConfigUrl,
  CookLog,
  CustomFilter,
  DefaultPageEnum,
  DeleteEnum,
  ExportLog,
  ExportRequest,
  FdcQuery,
  FdcQueryFoods,
  Food,
  FoodBatchUpdate,
  FoodInheritField,
  FoodShopping,
  FoodShoppingUpdate,
  FoodSimple,
  GenericModelReference,
  Group,
  Household,
  ImportLog,
  ImportOpenData,
  ImportOpenDataMetaData,
  ImportOpenDataResponse,
  ImportOpenDataResponseDetail,
  ImportOpenDataVersionMetaData,
  Ingredient,
  IngredientParserRequest,
  IngredientParserResponse,
  IngredientSimple,
  InventoryEntry,
  InventoryLocation,
  InventoryLog,
  InviteLink,
  InviteLinkEmail,
  Keyword,
  KeywordLabel,
  KeywordModeEnum,
  Localization,
  MealPlan,
  MealType,
  MethodEnum,
  ModelSync,
  NutritionInformation,
  PaginatedAiLogList,
  PaginatedAiProviderList,
  PaginatedAutomationList,
  PaginatedBookmarkletImportListList,
  PaginatedConnectorConfigList,
  PaginatedCookLogList,
  PaginatedCustomFilterList,
  PaginatedExportLogList,
  PaginatedFoodList,
  PaginatedGenericModelReferenceList,
  PaginatedHouseholdList,
  PaginatedImportLogList,
  PaginatedIngredientList,
  PaginatedInventoryEntryList,
  PaginatedInventoryLocationList,
  PaginatedInventoryLogList,
  PaginatedInviteLinkList,
  PaginatedKeywordList,
  PaginatedMealPlanList,
  PaginatedMealTypeList,
  PaginatedPropertyList,
  PaginatedPropertyTypeList,
  PaginatedRecipeBookEntryList,
  PaginatedRecipeBookList,
  PaginatedRecipeImportList,
  PaginatedRecipeOverviewList,
  PaginatedShoppingListEntryList,
  PaginatedShoppingListList,
  PaginatedShoppingListRecipeList,
  PaginatedSpaceList,
  PaginatedStepList,
  PaginatedStorageList,
  PaginatedSupermarketCategoryList,
  PaginatedSupermarketCategoryRelationList,
  PaginatedSupermarketList,
  PaginatedSyncList,
  PaginatedSyncLogList,
  PaginatedUnitConversionList,
  PaginatedUnitList,
  PaginatedUserFileList,
  PaginatedUserSpaceList,
  PaginatedViewLogList,
  PatchedAccessToken,
  PatchedAiProvider,
  PatchedAutomation,
  PatchedBookmarkletImport,
  PatchedConnectorConfig,
  PatchedCookLog,
  PatchedCustomFilter,
  PatchedExportLog,
  PatchedFood,
  PatchedHousehold,
  PatchedImportLog,
  PatchedIngredient,
  PatchedInventoryEntry,
  PatchedInventoryLocation,
  PatchedInviteLink,
  PatchedKeyword,
  PatchedMealPlan,
  PatchedMealType,
  PatchedProperty,
  PatchedPropertyType,
  PatchedRecipe,
  PatchedRecipeBook,
  PatchedRecipeBookEntry,
  PatchedRecipeImport,
  PatchedSearchPreference,
  PatchedShoppingList,
  PatchedShoppingListEntry,
  PatchedShoppingListRecipe,
  PatchedSpace,
  PatchedStep,
  PatchedStorage,
  PatchedSupermarket,
  PatchedSupermarketCategory,
  PatchedSupermarketCategoryRelation,
  PatchedSync,
  PatchedUnit,
  PatchedUnitConversion,
  PatchedUser,
  PatchedUserPreference,
  PatchedUserSpace,
  PatchedViewLog,
  Property,
  PropertyType,
  Recipe,
  RecipeBatchUpdate,
  RecipeBook,
  RecipeBookEntry,
  RecipeFlat,
  RecipeFromSource,
  RecipeFromSourceResponse,
  RecipeImage,
  RecipeImport,
  RecipeOverview,
  RecipeShoppingUpdate,
  RecipeSimple,
  SearchEnum,
  SearchFields,
  SearchPreference,
  ServerSettings,
  ShareLink,
  ShoppingList,
  ShoppingListEntry,
  ShoppingListEntryBulk,
  ShoppingListEntryBulkCreate,
  ShoppingListEntrySimpleCreate,
  ShoppingListRecipe,
  SourceImportDuplicate,
  SourceImportFood,
  SourceImportIngredient,
  SourceImportKeyword,
  SourceImportProperty,
  SourceImportPropertyType,
  SourceImportRecipe,
  SourceImportStep,
  SourceImportUnit,
  Space,
  SpaceNavTextColorEnum,
  SpaceThemeEnum,
  Step,
  Storage,
  Supermarket,
  SupermarketCategory,
  SupermarketCategoryRelation,
  SyncLog,
  ThemeEnum,
  Unit,
  UnitConversion,
  User,
  UserFile,
  UserFileView,
  UserPreference,
  UserPreferenceNavTextColorEnum,
  UserSpace,
  UserSpaceBatchUpdate,
  ViewLog,
])
Serializers serializers =
    (_$serializers.toBuilder()
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Automation)]),
            () => ListBuilder<Automation>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(RecipeBook)]),
            () => ListBuilder<RecipeBook>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(FoodSimple)]),
            () => ListBuilder<FoodSimple>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(UserPreference)]),
            () => ListBuilder<UserPreference>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Food)]),
            () => ListBuilder<Food>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Ingredient)]),
            () => ListBuilder<Ingredient>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SupermarketCategoryRelation)]),
            () => ListBuilder<SupermarketCategoryRelation>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(BookmarkletImportList)]),
            () => ListBuilder<BookmarkletImportList>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ViewLog)]),
            () => ListBuilder<ViewLog>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Storage)]),
            () => ListBuilder<Storage>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(RecipeBookEntry)]),
            () => ListBuilder<RecipeBookEntry>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(RecipeSimple)]),
            () => ListBuilder<RecipeSimple>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(GenericModelReference)]),
            () => ListBuilder<GenericModelReference>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SupermarketCategory)]),
            () => ListBuilder<SupermarketCategory>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Unit)]),
            () => ListBuilder<Unit>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(CustomFilter)]),
            () => ListBuilder<CustomFilter>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SourceImportDuplicate)]),
            () => ListBuilder<SourceImportDuplicate>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SearchFields)]),
            () => ListBuilder<SearchFields>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(User)]),
            () => ListBuilder<User>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ShoppingListRecipe)]),
            () => ListBuilder<ShoppingListRecipe>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Step)]),
            () => ListBuilder<Step>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SourceImportKeyword)]),
            () => ListBuilder<SourceImportKeyword>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(CookLog)]),
            () => ListBuilder<CookLog>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(FdcQueryFoods)]),
            () => ListBuilder<FdcQueryFoods>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(FoodInheritField)]),
            () => ListBuilder<FoodInheritField>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SourceImportProperty)]),
            () => ListBuilder<SourceImportProperty>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(PropertyType)]),
            () => ListBuilder<PropertyType>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Property)]),
            () => ListBuilder<Property>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType.nullable(JsonObject)]),
            () => ListBuilder<JsonObject>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(RecipeOverview)]),
            () => ListBuilder<RecipeOverview>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(AccessToken)]),
            () => ListBuilder<AccessToken>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType.nullable(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Localization)]),
            () => ListBuilder<Localization>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(IngredientSimple)]),
            () => ListBuilder<IngredientSimple>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(AiLog)]),
            () => ListBuilder<AiLog>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(RecipeFlat)]),
            () => ListBuilder<RecipeFlat>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(KeywordLabel)]),
            () => ListBuilder<KeywordLabel>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(RecipeImport)]),
            () => ListBuilder<RecipeImport>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Space)]),
            () => ListBuilder<Space>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(AiProvider)]),
            () => ListBuilder<AiProvider>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(InventoryLocation)]),
            () => ListBuilder<InventoryLocation>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(InventoryLog)]),
            () => ListBuilder<InventoryLog>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SourceImportIngredient)]),
            () => ListBuilder<SourceImportIngredient>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Keyword)]),
            () => ListBuilder<Keyword>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SourceImportStep)]),
            () => ListBuilder<SourceImportStep>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ModelSync)]),
            () => ListBuilder<ModelSync>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Household)]),
            () => ListBuilder<Household>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ConnectorConfig)]),
            () => ListBuilder<ConnectorConfig>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(UserFile)]),
            () => ListBuilder<UserFile>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ImportLog)]),
            () => ListBuilder<ImportLog>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ShoppingList)]),
            () => ListBuilder<ShoppingList>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Group)]),
            () => ListBuilder<Group>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(InviteLink)]),
            () => ListBuilder<InviteLink>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ShoppingListEntry)]),
            () => ListBuilder<ShoppingListEntry>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(MealPlan)]),
            () => ListBuilder<MealPlan>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(UserSpace)]),
            () => ListBuilder<UserSpace>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ExportLog)]),
            () => ListBuilder<ExportLog>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(UnitConversion)]),
            () => ListBuilder<UnitConversion>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(InventoryEntry)]),
            () => ListBuilder<InventoryEntry>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SearchPreference)]),
            () => ListBuilder<SearchPreference>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(MealType)]),
            () => ListBuilder<MealType>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(SyncLog)]),
            () => ListBuilder<SyncLog>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(ShoppingListEntrySimpleCreate),
            ]),
            () => ListBuilder<ShoppingListEntrySimpleCreate>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(Supermarket)]),
            () => ListBuilder<Supermarket>(),
          )
          ..add(const OneOfSerializer())
          ..add(const AnyOfSerializer())
          ..add(const DateSerializer())
          ..add(Iso8601DateTimeSerializer()))
        .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
