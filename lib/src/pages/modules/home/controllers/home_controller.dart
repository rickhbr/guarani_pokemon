import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guarani_poke_test/src/data/models/pokemon_model.dart';
import 'package:guarani_poke_test/src/data/models/relations_model.dart';
import 'package:guarani_poke_test/src/data/providers/pokemon_provider.dart';
import 'package:guarani_poke_test/src/data/repositories/pokemon_repository.dart';
import 'package:guarani_poke_test/src/globals/controllers/overlay_controller.dart';
import 'package:guarani_poke_test/src/utils/capitalize_letters.dart';
import 'package:guarani_poke_test/src/widgets/toast/toast.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeController extends GetxController {
  final PokemonRepository _pokemonRepository;
  RxBool isAbout = false.obs;
  RxBool isStats = false.obs;
  RxBool isEvolution = false.obs;
  RxBool isMoves = false.obs;
  RxBool isLoading = true.obs;
  RxBool hasFavoritesChanged = false.obs;

  RxList<PokemonModel> pokemons = <PokemonModel>[].obs;
  RxList<PokemonModel> favoritePokemons = <PokemonModel>[].obs;
  RxList<TypeRelations> typeRelationsList = <TypeRelations>[].obs;

  Rx<PokemonModel?> selectedPokemon = Rx<PokemonModel?>(null);

  HomeController() : _pokemonRepository = PokemonRepository(PokemonProvider());

  final ScrollController scrollController = ScrollController();
  final overlayController = Get.find<OverlayController>();
  var isLoadingMore = false.obs;

  int _loadedPokemonsCount = 0;

  @override
  void onInit() {
    isAbout(true);
    scrollController.addListener(_onScroll);
    fetchPokemons();
    super.onInit();
  }

  _onScroll() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels != 0) {
        loadMorePokemons();
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void onPokemonSelected(PokemonModel pokemon) {
    selectedPokemon.value = pokemon;
    for (var type in pokemon.types!) {
      int typeId = CapitalizeLetters.extractTypeIdFromUrl(type.type!.url!);
      fetchTypeRelations(typeId);
    }
  }

  Future<void> loadMorePokemons() async {
    try {
      isLoadingMore(true);
      int offset = pokemons.length;
      List<PokemonModel> newPokemons =
          await _pokemonRepository.fetchPokemonList(limit: 20, offset: offset);
      pokemons.addAll(newPokemons);
    } catch (error) {
    } finally {
      isLoadingMore(false);
    }
  }

  Future<void> fetchPokemons() async {
    try {
      isLoading(true);

      var box = await Hive.openBox<PokemonModel>('pokemons');
      var localPokemons = box.values.toList();

      if (localPokemons.isEmpty) {
        List<PokemonModel> fetchedPokemons = await _pokemonRepository
            .fetchPokemonList(offset: _loadedPokemonsCount);
        _loadedPokemonsCount += fetchedPokemons.length;
        pokemons.addAll(fetchedPokemons);

        for (var pokemon in fetchedPokemons) {
          box.put(pokemon.id, pokemon);
        }
      } else {
        pokemons.addAll(localPokemons);
      }

      isLoading(false);
    } catch (error) {
      isLoading(false);
    }
  }

  List<String>? getSelectedPokemonWeaknesses() {
    return selectedPokemon.value?.typeRelations?.doubleDamageFrom;
  }

  bool isPokemonFavorite(PokemonModel pokemon) {
    return favoritePokemons.contains(pokemon);
  }

  void updatePokemonList() {
    pokemons.refresh();
  }

  Future<void> fetchTypeRelations(int typeId) async {
    try {
      isLoading(true);
      TypeRelations fetchedTypeRelations =
          await _pokemonRepository.fetchTypeRelations(typeId);
      if (selectedPokemon.value != null) {
        selectedPokemon.value!.typeRelations = fetchedTypeRelations;
      }
      isLoading(false);
    } catch (error) {
      isLoading(false);
    }
  }

  void toggleFavoritePokemon(PokemonModel pokemon, BuildContext context) {
    if (favoritePokemons.contains(pokemon)) {
      Toast.showToast(
          context: context,
          error: true,
          text:
              '${CapitalizeLetters.capitalizeFirstLetter(favoritePokemons.first.name!)} removido dos favoritos');
      favoritePokemons.remove(pokemon);
    } else {
      favoritePokemons.add(pokemon);
      Toast.showToast(
          context: context,
          error: false,
          text:
              '${CapitalizeLetters.capitalizeFirstLetter(favoritePokemons.first.name!)} adicionado aos favoritos');
    }
    hasFavoritesChanged.value = !hasFavoritesChanged.value;
  }

  void selectAbout() {
    isAbout(true);
    isStats(false);
    isEvolution(false);
    isMoves(false);
  }

  void selectStats() {
    isAbout(false);
    isStats(true);
    isEvolution(false);
    isMoves(false);
  }

  void selectEvolution() {
    isAbout(false);
    isStats(false);
    isEvolution(true);
    isMoves(false);
  }

  void selectMoves() {
    isAbout(false);
    isStats(false);
    isEvolution(false);
    isMoves(true);
  }
}
