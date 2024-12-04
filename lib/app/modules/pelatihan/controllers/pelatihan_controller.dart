

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_smarcerti/app/data/models/pelatihanUser.dart';
// import 'package:mobile_smarcerti/app/data/provider/api_provider.dart';
// import 'package:mobile_smarcerti/app/modules/auth/controllers/base_controller.dart';
// import 'package:mobile_smarcerti/services/api_service.dart';
// import 'package:mobile_smarcerti/services/pelatihan_api.dart';

// class PelatihanController extends BaseController {
//   final PelatihanService pelatihanService = PelatihanService(ApiService());
//   final ApiProvider _apiProvider = ApiProvider();
//   RxList<PelatihanUser> pelatihans = <PelatihanUser>[].obs; // Daftar pelatihan
//   RxBool isLoading = false.obs; // Indikator loading
//   RxString errorMessage = ''.obs; // Pesan error
//   Rx<PelatihanUser?> pelatihanDetail = Rx<PelatihanUser?>(null); // Detail pelatihan
  

//   @override
//   void onInit() {
//     super.onInit();
//     initializeData();
//   }

//   /// Inisialisasi data pelatihan
//   Future<void> initializeData() async {
//     try {
//       await loadPelatihans();
//     } catch (e) {
//       handleError(e);
//     }
//   }

//   /// Fungsi untuk mengambil daftar pelatihan
//   Future<void> loadPelatihans() async {
//     try {
//       isLoading.value = true; // Menandakan loading dimulai
//       var data = await pelatihanService.getPelatihans(); // Memanggil API
//       if (data.isNotEmpty) {
//         pelatihans.assignAll(data); // Masukkan data ke observable
//       } else {
//         pelatihans.clear(); // Hapus data lama jika tidak ada data baru
//       }
//     } catch (e) {
//       print("Error saat mengambil pelatihan: $e");
//       errorMessage.value = 'Gagal memuat data pelatihan: $e';
//     } finally {
//       isLoading.value = false; // Pastikan loading selesai
//     }
//   }

//   /// Fungsi untuk memuat detail pelatihan berdasarkan ID
//   Future<void> loadPelatihanById(int id) async {
//     isLoading.value = true; // Menandakan loading dimulai
//     try {
//       // Memanggil fungsi API untuk mendapatkan detail pelatihan
//       PelatihanUser pelatihan = await pelatihanService.getPelatihanById(id);
//       pelatihanDetail.value = pelatihan; // Menyimpan detail pelatihan
//     } catch (e) {
//       // Jika terjadi error, reset nilai pelatihanDetail
//       print('Error saat mengambil detail pelatihan: $e');
//       pelatihanDetail.value = null;
//       errorMessage.value = 'Gagal memuat detail pelatihan: $e';
//     } finally {
//       isLoading.value = false; // Menandakan loading selesai
//     }
//   }


//     /// Fungsi untuk menambahkan pelatihan baru
//   Future<void> addPelatihan(Map<String, dynamic> newPelatihanData) async {
//     try {
//       isLoading.value = true; // Menandakan proses dimulai
//       var response = await pelatihanService.addPelatihan(newPelatihanData); // Panggil API untuk tambah pelatihan
//       if (response != null) {
//         pelatihans.add(response); // Tambahkan data baru ke daftar pelatihan
//         Get.snackbar(
//           "Berhasil",
//           "Pelatihan baru berhasil ditambahkan",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green.withOpacity(0.7),
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       print('Error saat menambahkan pelatihan: $e');
//       Get.snackbar(
//         "Gagal",
//         "Gagal menambahkan pelatihan: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.withOpacity(0.7),
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false; // Menandakan proses selesai
//     }
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_smarcerti/app/data/models/bidang_minat_pelatihan_model.dart';
import 'package:mobile_smarcerti/app/data/models/jenis_pelatihan_model.dart';
import 'package:mobile_smarcerti/app/data/models/mata_kuliah_pelatihan_model.dart';
import 'package:mobile_smarcerti/app/data/models/pelatihanUser.dart';
import 'package:mobile_smarcerti/app/data/models/periode_model.dart';
import 'package:mobile_smarcerti/app/data/models/vendor_pelatihan_model.dart';
// import 'package:mobile_smarcerti/app/data/models/pelatihan_model.dart';
import 'package:mobile_smarcerti/app/data/provider/api_provider.dart';
import 'package:mobile_smarcerti/app/modules/auth/controllers/base_controller.dart';
import 'package:mobile_smarcerti/services/api_service.dart';
import 'package:mobile_smarcerti/services/pelatihan_api.dart';

class PelatihanController extends BaseController {
  final PelatihanService pelatihanService = PelatihanService(ApiService());
  final ApiProvider _apiProvider = ApiProvider();
  final PelatihanService lspService = PelatihanService(ApiService());
  RxList<PelatihanUser> pelatihans = <PelatihanUser>[].obs; // Daftar pelatihan
  RxBool isLoading = false.obs; // Indikator loading
  RxString errorMessage = ''.obs; // Pesan error
  Rx<PelatihanUser?> pelatihanDetail = Rx<PelatihanUser?>(null); // Detail pelatihan
  

  // List observables untuk vendor, bidang minat, dan mata kuliah
  var vendorList = <VendorPelatihan>[].obs;
  var bidangMinatList = <BidangMinatPelatihan>[].obs;
  var mataKuliahList = <MataKuliahPelatihan>[].obs;
  var jenisPelatihanList = <JenisPelatihan>[].obs;
    var tahunPeriode = <Periode>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  /// Inisialisasi data pelatihan
  // Future<void> initializeData() async {
  //   try {
  //     await loadPelatihans();
      
  //   } catch (e) {
  //     handleError(e);
  //   }
  // }

    Future<void> initializeData() async {
    await Future.wait([
      loadPelatihans(),
      loadVendors(),
      loadBidangMinat(),
      loadMataKuliah(),
      loadPeriode(),
    ]);
  }


  /// Fungsi untuk mengambil daftar pelatihan
  Future<void> loadPelatihans() async {
    try {
      isLoading.value = true; // Menandakan loading dimulai
      var data = await pelatihanService.getPelatihans(); // Memanggil API
      if (data.isNotEmpty) {
        pelatihans.assignAll(data); // Masukkan data ke observable
      } else {
        pelatihans.clear(); // Hapus data lama jika tidak ada data baru
      }
    } catch (e) {
      print("Error saat mengambil pelatihan: $e");
      errorMessage.value = 'Gagal memuat data pelatihan: $e';
    } finally {
      isLoading.value = false; // Pastikan loading selesai
    }
  }

  /// Fungsi untuk memuat detail pelatihan berdasarkan ID
  Future<void> loadPelatihanById(int id) async {
    isLoading.value = true; // Menandakan loading dimulai
    try {
      // Memanggil fungsi API untuk mendapatkan detail pelatihan
      PelatihanUser pelatihan = await pelatihanService.getPelatihanById(id);
      pelatihanDetail.value = pelatihan; // Menyimpan detail pelatihan
    } catch (e) {
      // Jika terjadi error, reset nilai pelatihanDetail
      print('Error saat mengambil detail pelatihan: $e');
      pelatihanDetail.value = null;
      errorMessage.value = 'Gagal memuat detail pelatihan: $e';
    } finally {
      isLoading.value = false; // Menandakan loading selesai
    }
  }


    /// Fungsi untuk menambahkan pelatihan baru
  // Future<void> addPelatihan(Map<String, dynamic> newPelatihanData) async {
  //   try {
  //     isLoading.value = true; // Menandakan proses dimulai
  //     var response = await pelatihanService.addPelatihan(newPelatihanData); // Panggil API untuk tambah pelatihan
  //     if (response != null) {
  //       pelatihans.add(response); // Tambahkan data baru ke daftar pelatihan
  //       Get.snackbar(
  //         "Berhasil",
  //         "Pelatihan baru berhasil ditambahkan",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.green.withOpacity(0.7),
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     print('Error saat menambahkan pelatihan: $e');
  //     Get.snackbar(
  //       "Gagal",
  //       "Gagal menambahkan pelatihan: $e",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red.withOpacity(0.7),
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isLoading.value = false; // Menandakan proses selesai
  //   }
  // }

 Future<void> createPelatihan(Map<String, dynamic> data) async {
    isLoading.value = true;

    try {
      final PelatihanUser? result = await lspService.createPelatihan(data);
      if (result != null) {
        pelatihans.add(result); // Tambahkan pelatihan baru ke daftar
        Get.snackbar(
          'Berhasil',
          'Pelatihan berhasil ditambahkan.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        errorMessage.value = 'Gagal membuat pelatihan.';
        Get.snackbar(
          'Gagal',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = 'Gagal membuat pelatihan: $e';
      Get.snackbar(
        'Gagal',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Memuat data vendor
  Future<void> loadVendors() async {
    try {
      isLoading.value = true;
      var data = await lspService.getVendorpelatihan();
      vendorList.assignAll(data); // Perbaiki untuk mengisi ke vendorList
    } catch (e) {
      print("Error saat mengambil vendor pelatihan: $e");
      errorMessage.value = 'Gagal memuat data vendor pelatihan.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Memuat data bidang minat
  Future<void> loadBidangMinat() async {
    try {
      isLoading.value = true;
      var data = await lspService.getBidangMinat();
      bidangMinatList.assignAll(data);
    } catch (e) {
      print("Error saat mengambil bidang minat: $e");
      errorMessage.value = 'Gagal memuat data bidang minat.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Memuat data periode
  Future<void> loadPeriode() async {
    try {
      isLoading.value = true;
      var data = await lspService.getPeriode();
      tahunPeriode.assignAll(data);
    } catch (e) {
      print("Error saat mengambil periode: $e");
      errorMessage.value = 'Gagal memuat data periode.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Memuat data mata kuliah
  Future<void> loadMataKuliah() async {
    try {
      isLoading.value = true;
      var data = await lspService.getMataKuliah();
      mataKuliahList.assignAll(data);
    } catch (e) {
      print("Error saat mengambil mata kuliah: $e");
      errorMessage.value = 'Gagal memuat data mata kuliah.';
    } finally {
      isLoading.value = false;
    }
  }
  

    Future<void> loadJenisPelatihan() async {
    try {
      isLoading.value = true;
      var data = await lspService.getJenisPelatihan();
      jenisPelatihanList.assignAll(data);
    } catch (e) {
      print("Error saat mengambil jenis Pelatihan: $e");
      errorMessage.value = 'Gagal memuat data jenis Pelatihan.';
    } finally {
      isLoading.value = false;
    }
  }
}
