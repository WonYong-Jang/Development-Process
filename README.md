# Development-Process
It is where I record the error fixes or learning during the development process.


## 자바 최적화 교재 Study

### Java 의 Stack 과 Heap

**Stack**

- Heap 영역에 생성된 Object 타입의 데이터의 참조값이 할당 
- 각 Thread는 자신만의 stack을 가짐(각 스레드에서 다른 스레디의 stack 접근 불가!)  
- 원시타입(primitive types)의 데이터들이 할당됨 => 이때 원시타입의 데이터들의 참조값이 아닌 실제 값을 stack에 저장!!
- main() 함수 종료 되는 순간 stack 에 모든 데이터 pop

**Heap**

- 주로 긴 생명주기를 가진 데이터 ( 모든 메모리 중 stack 에 있는 데이터를 제외한 부분이라고 생각해도 될정도)
- 모든 Object 타입(Integer, String, ArrayList..) 
- 몇개의  스레드가 존재하든 상관없이 단 하나의 heap 영역만 존재
- Heap 영역에 있는 오브젝트들을 가르키는 레퍼런스 변수가 stack 에 올라감 

주의) Heap 영역에 있는 데이터는 함수 내부에서 파라미터로 받아서 변경하고  
    함수 호출이 종료된 시점에 변경 내역이 반영되는 것을 확인 !!

```
List<String> list = new ArrayList<>();
solve(list);
==> solve 함수에서 list 를 변경하면 그대로 반영됨! 힙영역에 있으므로 !

```

주의 ) 아래와 같이 Integer는 heap 영역에서 관리하는 Object 타입인데
변경되지 않는 이유는 String과 동일하게 불변객체(immutable)이기 때문

- Wrapper class 에 해당하는 Integer, Character, Byte, Boolean, Long, Double, Float, Short 클래스 모두 Immutable

```
Integer a = 10;
solve(a); 
=> solve 함수에서 값을 변경하면 바뀌지 않는다!!!
```
=> 실행 순서는 a가 가르키는 10은 heap 에 생성되지만 solve 라는 함수로   
param = 10 으로 넘어갈때 Wrapper class 는 기존에 레러펀스하고 있던 값을  
새롭게 생성된 오브젝트를 만들기 때문에 함수가 끝나고 나면 변경된 값 pop 되기때문 !!!   




### JVM

- Java Virtual Machine 은 자바를 실행하기 위한 자바 가상 머신
- 자바와 운영체제사이에서 중계자 역할을 함
- 자바가 운영체제 종류에 영향을 받기 않고 돌아갈수 있도록 함
=> CPU나 운영체제(플랫폼)에 의존적이지 않고 독립적으로 JAVA프로그램이 실행할수 있도록!  
- 메모리 관리를 자동을 해준다(GC)
- 운영체제 위에서 동작하는 프로세스로 자바 코드를 컴파일해서 얻은 바이트 코드를 해당 운영체제가 이해할수 있는 기계어로 바꿔실행 시켜주는역할!
- 현재 프로세스에서 메모리 누수가 발생하더라도 현재 실행중인것만 죽고 다른것에는 영향 주지 않음!

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

```
String url = "abc";
url += "def";

=> + 하는 순간 새롭게 "abcdef" 라는 객체를 만들고 url이 레퍼런스
==> 처음 "abc" 오브젝트는 Unreachable 오브젝트라 하고 GC의 대상!!
```


- Stop The World : GC 실행을 위해 JVM이 애플리케이션 실행을 멈추는 것(GC 튜닝이랑 이 시간을 줄이는 것)
- Mark and Sweep 이라고도 함( GC가 스택의 모든 변수 또는 Reachable 객체를 스캔하면서 어떤 객체를 참조하는지 찾는 과정을 Mark이며 이과정에서 Stop The world 발생 / 이두 Mark 되어있지 않은 객체들을 힙에서 제거 하는 과정을 Sweep
- GC가 역할을 하는 시간은 정확히 언제인지를 알수 없음( 참조가 없어지자마다 해제되는 것을 보장하지 않음)
- GC가 수행되는 동안 GC를 수행하는 쓰레드가 아닌 다른 모든 쓰레드가 일시정지됨
- 특히 Full GC가 일어나서 수 초간 모든 쓰레드가 정지한다면 장애로 이어지는 치명적인 문제가 생길수 있음!

**Minor GC와 Major GC**
- JVM의 Heap 영역은 Young, Old, Perm 세 영역으로 나뉨
- young 영역에서 발생한 GC를 Minor GC, 나머지 두 영역에서 발생한 GC를 Major GC(Full GC)

- young 영역 : 새롭게 생성한 객체가 위치, 대부분의 객체가 금방 unreachable 상태가 되기 때문에 많은 객체가 Young 영역에 생성되었다가 사라짐
- old 영역 : Young영역에서 reachable 상태를 유지해 살아남은 객체가 여기로 복사됨. 대부분 Young 영역보다 크게 할당하며, 크기가 큰 만큼 Young 영역보다 GC는 적게 발생
- Perm 영역 : Method Area라고도 함 / 클래스와 메소드 정보와 같이 자바 언어 레벨에서는 거의 사용되지 않음

**Reachability**

- Java의 GC는 가비지 객체를 판별하기 위해 reachability 라는 개념을 사용함
- 어떤 객체에 유효한 참조가 있으면 reachable 없으면 unreachable로 구분하고 가비지로 간주함
- 바꿔 말하면 객체에 대한 reachability를 제어 할수 있다면 코드를 통해 GC에 일부 관여하는 것이 가능
- java는 이를 위해서 SoftReference, WeakReference 등 제공

- 캐시 등을 만들때 메모리 누수 조심 ( 캐시의 키가 원래 데이터에서 삭제된다면 캐시 내부의 키와 값은 더이상 의미 없는 데이터이지만 GC는 삭제된 캐시의 키를 가비지로 인식 못함 ! )
=> 캐시에 Weak Reference를 넣어준다면 이러한 문제 방지 가능 (WeakHashMap)

**Runtime Data Areas(JVM 메모리)**

- JVM 메모리로 java 어플리케이션 실행하면서 할당 받은 메모리 영역 
- Method, Runtime Constant Pool, Heap, Stack, PC Register, Native Method Stack)

  1) Method area 영역 : 클래스 멤버 변수 


### GC 로깅

- System.gc() // 가비지 컬렌션이 일어나도록 코드 삽입 할수 있지만 모든 스레드 중단되기 때문에 코드단에서 절때 호출 하지 말것 

**JVM 옵션 정리**

```
-verbose:gc                     //
-XX:+PrintCommandLineFlag       // 어떤 가비지 컬렉터를 사용하는지 볼수 있음
-Xms
-Xmx

```

-Xmx16m -verbose:gc -XX:+PrintCommandLineFlags // OutofMemoryError를 빨리 내기 위해 jvm 옵션 설정 

1) 프로그램이 메모리 부족으로 죽는 경우 

- java.lang.OutOfMemoryError: Java heap space 에러 발생 ! 
- 무한루프 외부에서 선언한 ArrayList는 무한루프가 도는 동안에도 계속해서 Reachable 하기 때문에 (레퍼런스가 끊이질 않기때문에 가비지 컬렉션 작업이 진행되어도 힙에 모든 데이터가 남아 있게 됨!)
=> 무한루프를 돌기때문에 프로그램이 죽은 것이 가비지 컬렉션이 수행되어도 모든 오브젝트가 살아 있기 때문에 OOM 에러 발생 !   

```
public class ListGCTest {
    public static void main(String[] args) throws Exception {
        List<Integer> li = IntStream.range(1, 100).boxed().collect(Collectors.toList());
        for (int i=1; true; i++) {
            if (i % 100 == 0) {
                Thread.sleep(100);
            }
            IntStream.range(0, 100).forEach(li::add);
        }
    }
}
```

2) 가비지 컬렉터가 열일하여 프로그램이 죽지 않는 경우 

```
public class ListGCTest {
    public static void main(String[] args)throws Exception {
        List<Integer> li = IntStream.range(1, 100).boxed().collect(Collectors.toList());
        for (int i=1; true; i++) {
            if (i % 100 == 0) {
                li = new ArrayList<>();
                Thread.sleep(100);
            }
            IntStream.range(0, 100).forEach(li::add);
        }
    }
}
```

- 위의 내용은 100번째 단위로 루프를 돌때마다 기존에 가지고 있던 리스트를 가비지로 만들어주니 프로그램이 죽지 않고 계속 돌아감 ! 

### 메모리 구성 Metaspace 와 Heap

1) Metaspace

- 자바 8에 적용된 변화는 람다, 스트림, 인터페이스의 default 지시자가 대표적!
- 메모리 관점에서 가장 큰 변화는 PermGen 이 사라지고 Metaspace 가 이를 대체하게 됨!

1-1) PermGen 은 자바 7까지 메타데이터를 저장하던 영역이였고 Heap의 일부

- Permanent Generation은 힙 메모리 영역중에 하나로 자바 애플리케이션을 실행할 때 클래스의 메타데이터를 저장하던 영역 (자바 7기준)  
- OutOfMemoryError: PermGen Space error 는 더이상 볼수 없고 JVM 옵션으로 사용했던 PermSize 와 MaxPermSize는 더이상 사용할 필요가 없다. 이 대신에 MetaspaceSize 및 MaxMetaspaceSize가 새롭게 사용되게 됨  

==> 자바 8부터 클래스들은 모두 힙이 아닌 네이티브 메모리를 사용하는 Metaspace에 할당 됨

```
public class MetaspaceTest {
    static javassist.ClassPool cp = javassist.ClassPool.getDefault();

    public static void main(String[] args) throws Exception{
        for (int i = 0; ; i++) {
            if (i % 1000 == 0) Thread.sleep(100);
            Class c = cp.makeClass("test" + i).toClass();
        }
    }
}
```

- 위 코드는 metaspace를 사용하게 될 class 들을 런타임시에 생성 
- javassist 라이브러리 추가하고 VIsualVm 에서 모니터링! ( vm 옵션으로 -XX:MaxMetaspaceSize=128m 주고 실행시킴 ! ) 
- java.lang.OutOfMemoryError:Metaspace 에러로 프로그램이 죽음 

2) Heap - Old & Young ( Eden, Survivor)

- Heap 은 Young Generation, Old Generation 으로 크게 두개의 영역으로 나뉘어짐 
- Young Generation 은 또다시 Eden, Survivor Space 0, 1 로 세분화 되어짐! 
- S0, S1 으로 표시되는 영역이 Survivor Space 0, 1

**가비지 컬렉션 프로세스**

- 새로운 오브젝트는 Eden 영역에 할당 됨. 두개의 Survivor Space 는 비워진 상태로 시작함
- Eden 영역이 가득차면, MinorGC가 발생함
- MinorGC가 발생하면, Reachable 오브젝트들은 S0 으로 옮겨진다. Unreachable 오브젝트들은 Eden 영역이 클리어 될때 함께 메모리에서 사라짐 !!  
- 다음 Minor GC가 발생할때, Eden 역에는 3번과 같은 과정이 발생함. Unreachable 오브젝트들은 지워지고, Reachable 오브젝트들은 Survivor Space 로 이동함. 기존에 S0 에 있었던 Reachable 오브젝트들은 S1으로 옮겨지는데, 이째 age값이 증가되어 옮겨진다. 살아남은 모든 오브젝트들이 S1으로 모두 옮겨지면, S0 와 Eden은 클리어 됨. 
=> Survivor Space 에서 Survivor Space 로의 이동은 이동할때마다 age 값이 증가한다.   

- 다음 MinorGC가 발생하면, 4번과정이 반복되는데 S1 이 가측차 있었으므로 S1에서 살아남은 오브젝트들은 S0로 옮겨지면서 Eden 과 S1 은 클리어 된다. 이때에도 age값이 증가되어 옮겨진다.

- Young Generation 에서 계속해서 살아남으며 age 값이 증가하는 오브젝트들은 age 값이 특정값 이상이 되면 Old Generation 으로 옮겨지는데 이 단계를 Promotion 이라고 함 !!!     

- MinorGC가 계속 반복되면, Promtion 작업도 꾸준히 발생하게 됨!! 
- Promiton 작업이 계속해서 반복되면서 Old Generation 이 가득차게 되면 MajorGC가 발생하게 됨!!!  

**용어 정리**

- MinorGC : Young Generation 에서 발생하는 GC
- MajorGC : Old Generation 에서 발생하는 GC
- FullGC : Heap 전체를 clear 하는 작업(Young/Old 공간 모두)   




### JVM 모니터링과 툴링

**VisualVM**

- jdk 1.6 이상부터는 별도의 설치 없이 실행 가능 ( /bin/jvisualvm )

- jconsole을 대체하는 툴 => JVM을 실시간으로 모니터링 할수 있는 오픈소스 기반 툴
- heap 덤프 및 쓰레드 덤프 가능
- VisualGC 플러그인 설치 (VisualVM 에서 Toll > Plugins > Available Plugins 에서 install )



### 메모리 누수 해결책

1) WeakReference vs StrongReference

- StrongReference : new() 객체 생성 방법
 => 가장 먼저 참조되어지는 root객체로부터 사슬이 계속 연결되어 있는가 여부에 따라서 GC의 대상  
 => GC에서 무조건 제외되기 때문에 메모리 누수 유발 가능  

- WeakReference : 명확하게 GC에 의한 메모리상의 회수 대상이 됨
  => 짧은 시간, 자주 쓰일 수 있는 객체를 이용할때 유용 


2) WeakReference 구현
- 참조할 객체를 캡슐화해서 객체로 제공  

```
WeakReference wr;

public String getFileContent(String filename) {
    // WeakReference 에 의해 파일 내용이 보존되어 있는지 체크
    String fileContent = (wr != null) ? wr.get() : null;

    if(fileContent == null) {
        // 글 내용이 비었으면 파일 이름으로 내용을 읽어와 채워준다.
        fileContent = fileToString(filename);
        // 채워진 글 내용을 WeakReference 에 저장한다.
        wr = new WeakReference(fileContent);
    }
    return fileContent;
}

```
- GC가 발생하기 전까진 WeakReference가 글 내용을 가지고 있으면 캐쉬 역할을 하지만 GC 발생하면 wr.get()은 null을 반환하고 다시채움으로써 메모리 누수 방지 !
- 생성한 객체는 get 메소드로 얻어옴 

- WeakHashMap 



참고 : https://yaboong.github.io/java/2018/06/09/java-garbage-collection/

