import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personVo.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  //기본레이아웃
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("리스트페이지")),
        body: Container(
            padding: EdgeInsets.all(15),
            color: Color(0xffd6d6d6),
            child: _ListPage()
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed( context, '/write', );
          },
          child: Icon(Icons.add),
        ),
    );
  }
}

// 등록
class _ListPage extends StatefulWidget {
  const _ListPage({super.key});

  @override
  State<_ListPage> createState() => _ListPageState();
}

// 할일
class _ListPageState extends State<_ListPage> {
  // 공통 변수
  late Future<List<PersonVo>> personListFuture;

  // 생애주기별 훅

  // 초기화할때
  @override
  void initState() {
    super.initState();
    personListFuture = getPersonList();
  }

  // 그림그릴때
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: personListFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else { //데이터가 있으면

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                      width: 50,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      color: Color(0xffffffff),
                      child: Text("${snapshot.data![index].personId}", style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                      width: 100,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      color: Color(0xffffffff),
                      child: Text("${snapshot.data![index].name}", style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                      width: 160,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      color: Color(0xffffffff),
                      child: Text("${snapshot.data![index].hp}", style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                      width: 160,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      color: Color(0xffffffff),
                      child: Text("${snapshot.data![index].company}", style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    color: Color(0xffffffff),
                    child: IconButton
                      (
                        onPressed: () {

                          print("page이동");

                          Navigator.pushNamed(
                              context,
                              "/read",
                              arguments: {
                                "personId": snapshot.data![index].personId
                              },
                          );
                        },
                        icon:
                        Icon(Icons.arrow_forward)
                    ),
                  ),
                ],
              );
            },
          );




        } // 데이터가있으면
      },
    );

  }

  //리스트가져오기 dio통신
  Future< List<PersonVo> > getPersonList() async {
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.get(
        'http://localhost:9003/api/phonebooks',
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경
        print(response.data.length); // json->map 자동변경
        print(response.data[0]); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);

        List<PersonVo> personList = [];
        for (int i = 0; i < response.data.length; i++) {
          PersonVo personVo = PersonVo.fromJson(response.data[i]);
          personList.add(personVo);
        }
        print(personList);
        return personList;
        
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  } //getPersonList()





}
