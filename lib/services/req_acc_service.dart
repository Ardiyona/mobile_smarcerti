import 'package:dio/dio.dart';
import 'package:mobile_smarcerti/app/data/models/pelatihan_model.dart';
import 'package:mobile_smarcerti/app/data/models/sertifikasi_model.dart';
import 'package:mobile_smarcerti/app/utils/constant.dart';
import 'package:mobile_smarcerti/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReqAccService {
  final ApiService apiService;

  ReqAccService(this.apiService);
  final Dio _dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      followRedirects: true,
      receiveTimeout: const Duration(seconds: 15),
      connectTimeout: const Duration(seconds: 15),
    );

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    return token;
  }

  // Fungsi untuk mendapatkan data req pelatihan
  Future<List<Pelatihan>> getReqPelatihans() async {
    final token = await getToken(); // Ambil token dari helper atau auth service
    if (token == null) throw Exception("Token not found");

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}penerimaanPelatihans',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Mengakses data yang berada dalam pelatihans -> data
        var json = response.data;
        final parsed = json['data'].cast<Map<String, dynamic>>();
        return parsed
            .map<Pelatihan>((json) => Pelatihan.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load req pelatihans');
      }
    } catch (e) {
      print('Error fetching pelatihans: $e');
      throw Exception('Error fetching req pelatihans: $e');
    }
  }

  // Fungsi untuk mendapatkan data sertifikasi dosen
  Future<List<Sertifikasi>> getReqSertifikasis() async {
    final token = await getToken(); // Ambil token dari helper atau auth service
    if (token == null) throw Exception("Token not found");

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}penerimaanSertifikasis',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Mengakses data yang berada dalam pelatihans -> data

        var json = response.data;
        final parsed = json['data'].cast<Map<String, dynamic>>();

        return parsed
            .map<Sertifikasi>((json) => Sertifikasi.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load req sertifikasis');
      }
    } catch (e) {
      print('Error fetching sertifikasis: $e');
      throw Exception('Error fetching req sertifikasis: $e');
    }
  }

  Future<void> updateStatusPelatihan(String status, String id) async {
    final token = await getToken(); // Ambil token dari helper atau auth service
    if (token == null) throw Exception("Token not found");

    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}penerimaanPelatihans/updateStatusPelatihan/$id', // Sesuaikan endpoint dengan API yang ada
        data: {
          'status_pelatihan': status, // Kirim status baru ke API
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Jika status berhasil diperbarui
        print("Status berhasil diperbarui: $status");
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      print('Error updating status: $e');
      throw Exception('Error updating status: $e');
    }
  }

  Future<void> updateStatusSertifikasi(String status, String id) async {
    final token = await getToken(); // Ambil token dari helper atau auth service
    if (token == null) throw Exception("Token not found");

    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}penerimaanSertifikasis/updateStatusSertifikasi/$id', // Sesuaikan endpoint dengan API yang ada
        data: {
          'status_sertifikasi': status, // Kirim status baru ke API
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Jika status berhasil diperbarui
        print("Status berhasil diperbarui: $status");
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      print('Error updating status: $e');
      throw Exception('Error updating status: $e');
    }
  }
}
