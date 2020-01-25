# Development-Process
It is where I record the error fixes or learning during the development process.


## 자바 최적화 교재 Study

### JVM

- Java Virtual Machine 은 자바를 실행하기 위한 자바 가상 머신
- 자바와 운영체제사이에서 중계자 역할을 함
- 자바가 운영체제 종류에 영향을 받기 않고 돌아갈수 있도록 함
=> CPU나 운영체제(플랫폼)에 의존적이지 않고 독립적으로 JAVA프로그램이 실행할수 있도록!  
- 메모리 관리를 자동을 해준다(GC)
- 운영체제 위에서 동작하는 프로세스로 자바 코드를 컴파일해서 얻은 바이트 코드를 해당 운영체제가 이해할수 있는 기계어로 바꿔실행 시켜주는역할!

<img width="700" alt="스크린샷 2020-01-23 오후 7 44 03" src="https://user-images.githubusercontent.com/26623547/73117802-78a1d880-3f8e-11ea-9b14-1a98fb652380.png">

**Java Compiler**
-  java source(.java) 파일은 Byte code(.class) 로 변환됨
 
**Class Loader**

- 변환된 Byte code(.class) 파일을 JVM이 운영체제로 부터 할당 받은 메모리 영역인 Runtime Data Area로 적재하는 역할

**Execution Engine**

- Class Loader를 통해 JVM 내부로 넘어와 Runtime Data Area(JVM 메모리)에 배치된 Byte code들을 기계어로 변경해 명령어 단위로 실행하는 역할


 1) 인터프리터 컴파일 방식 : 명령어를 하나하나 실행
 2) JIT(Just-In-Time) 컴파일 방식 : 

**GC**

- Heap 메모리 영역에 생성된(적재)된 객체들 중에 참조되지 않은 객체들을 탐색 후 제거하는 역할
- GC가 역할을 하는 시간은 정확히 언제인지를 알수 없음( 참조가 없어지자마다 해제되는 것을 보장하지 않음)
- GC가 수행되는 동안 GC를 수행하는 쓰레드가 아닌 다른 모든 쓰레드가 일시정지됨
- 특히 Full GC가 일어나서 수 초간 모든 쓰레드가 정지한다면 장애로 이어지는 치명적인 문제가 생길수 있음!


**Runtime Data Areas(JVM 메모리)**

- JVM 메모리로 java 어플리케이션 실행하면서 할당 받은 메모리 영역 
- Method, Runtime Constant Pool, Heap, Stack, PC Register, Native Method Stack)

  1) Method area 영역 : 클래스 멤버 변수 


### JVM 모니터링과 툴링

**VisualVM**

- jdk 1.6 이상부터는 별도의 설치 없이 실행 가능 ( /bin/jvisualvm )

- jconsole을 대체하는 툴 => JVM을 실시간으로 모니터링 할수 있는 오픈소스 기반 툴
- heap 덤프 및 쓰레드 덤프 가능 

