import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personVo.dart';

class ModifyForm extends StatelessWidget {
  const ModifyForm({super.key});

  // 기본레이아웃
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("수정페이지"),
      ),
      body: _ModifyForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}

// 상태변화를 감시하게 등록 시키는 클래스
class _ModifyForm extends StatefulWidget {
  const _ModifyForm({super.key});

  @override
  State<_ModifyForm> createState() => _ModifyFormState();
}

// 할일 정의 클래스(통신, 데이터적용)
class _ModifyFormState extends State<_ModifyForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  // 라우터
  late final args = ModalRoute.of(context)!.settings.arguments as Map;

  // 변수
  late Future<PersonVo> personVoFuture;

  // 초기화 함수(1번만 실행됨)
  @override
  void initState() {
    super.initState();
  }

  // 화면그리기
  @override
  Widget build(BuildContext context) {
    // ModalRoute를 통해 현재 페이지에 전달된 arguments를 가져옵니다.
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    // 'personId' 키를 사용하여 값을 추출합니다.
    final personId = args['personId'];

    // 추가코드   // 데이터 불러괴 메소드 호출
    print("initState(): 데이터 가져오기 전");
    personVoFuture = getPersonByNo(personId);
    print("initState(): 데이터 가져오기 후");

    print("================================");
    print(personId);
    print("================================");

    print("Build(): 그리기 작업");

    return FutureBuilder(
      future: personVoFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else {
          //데이터가 있으면
          // _nameController.text = snapshot.data!.name;
          return Container(
            padding: EdgeInsets.all(15),
            color: Color(0xffd6d6d6),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 70,
                          height: 50,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "번호",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                          width: 400,
                          height: 50,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${snapshot.data!.personId}",
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 70,
                          height: 50,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "이름",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                        width: 400,
                        height: 50,
                        color: Color(0xffffffff),
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: '이름',
                              hintText: '이름을 입력하세요',
                              border: OutlineInputBorder(),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 70,
                          height: 50,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "핸드폰",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                        width: 400,
                        height: 50,
                        color: Color(0xffffffff),
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                            controller: _hpController,
                            decoration: InputDecoration(
                              labelText: '핸드폰',
                              hintText: '핸드폰번호를 입력하세요',
                              border: OutlineInputBorder(),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 70,
                          height: 50,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "회사",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                        width: 400,
                        height: 50,
                        color: Color(0xffffffff),
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                            controller: _companyController,
                            decoration: InputDecoration(
                              labelText: '회사',
                              hintText: '회사번호를 입력하세요',
                              border: OutlineInputBorder(),
                            )),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: SizedBox(
                          width: 450,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                print("데이터전송");
                                modifyPerson(personId);
                              },
                              child: Text("수정")),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } // 데이터가있으면
      },
    );
    ;
  }

  // 1명 데이터 가져오기 return    그림x
  Future<PersonVo> getPersonByNo(int pId) async {
    print(pId);
    print("initState(): 데이터 가져오기 중");
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.get(
        'http://localhost:9003/api/phonebooks/modify/${pId}',
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경

        // print(response.data["apiData"]);
        return PersonVo.fromJson(response.data);
        //return PersonVo.fromJson(response.data["apiData"]);
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }

  //수정하기
  Future<void> modifyPerson(int pId) async {
    print("3errwrrqwr");
    print(pId);
    print("3errwrrqwr");
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();
      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.put(
        'http://localhost:9003/api/phonebooks/modify/${pId}',
        data: {
          // 예시 data map->json자동변경
          'name': _nameController.text,
          'hp': _hpController.text,
          'company': _companyController.text,
        },
      );
      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);
        Navigator.pushNamed(
          context,
          "/list",
        );
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  } //deletePerson()
}
