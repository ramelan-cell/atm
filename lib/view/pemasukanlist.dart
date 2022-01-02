class PemasukanList {
  PemasukanList(
      {this.id, this.tanggal, this.kategori, this.jenis_dana, this.nominal});
  String id;
  String tanggal;
  String kategori;
  String jenis_dana;
  String nominal;

  factory PemasukanList.fromJson(Map<String, dynamic> json) => PemasukanList(
      id: json["id"],
      tanggal: json["tanggal"],
      kategori: json["kategori"],
      jenis_dana: json["jenis_dana"],
      nominal: json['nominal']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "tanggal": tanggal,
        "kategori": kategori,
        "jenis_dana": jenis_dana,
        "nominal": nominal,
      };
}
