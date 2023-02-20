# 課題1
## SOLID原則とは（メリットも含めて説明）
変更に強いソフトウェアを作るための5つの設計原則の頭文字を取った言葉。
1. Single Responsibility Principle：単一責任の原則
各クラスはそれぞれ一つだけの責務を持つべきであるという原則。ここでの責務というのは、そのクラスを利用するアクターに対する責務を意味する。つまり、各クラスは各アクターと1対1で紐づいているべきであるということ。
単一責任の原則を守るメリットは仕様変更の際に影響範囲を小さく保てること。
参考：https://www.ogis-ri.co.jp/otc/hiroba/others/OOcolumn/single-responsibility-principle.html
2. Open/closed principle：オープン/クロースドの原則
ソフトウェアの構成要素（クラス、関数など）は拡張に対して開かれていて（Open）修正に対して閉じて（closed）いなければならないという原則。つまり、拡張はしやすいが、修正時は既存の成果物を変更する必要がないような設計にするべきということ。
参考：https://zenn.dev/rafael612/articles/5d68b432d219f8
3. Liskov substitution principle：リスコフの置換原則
クラスを継承するときに、スーパークラスとサブクラスを入れ替えても動くようにするべきという原則。is-aの関係が成り立っているからとよく考えずにクラス設計すると、あるサブクラスで矛盾が生まれてしまうことがある。
参考：https://www.membersedge.co.jp/blog/typescript-solid-liskov-substitution-principle/
4. Interface segregation principle：インターフェース分離の原則
インターフェースとその利用者がいるとき、利用者にとって必要のないメソッドやプロパティに依存しなくていいようにインターフェースを分割すべきであるという原則。
参考：https://www.membersedge.co.jp/blog/typescript-solid-interface-segregation-principle/
5. Dependency inversion principle：依存性逆転の原則
あるモジュールが別のモジュールを利用するとき、間に共有された抽象（インターフェースや抽象クラスなど）に依存するべきという原則。

下記記事の例を見たが、これでは依存性逆転の原則のメリットが分からなかった。
これはインターフェースを用意したというよりかは、validateTypeの処理をfetchUserに移動したからaxiosに変更しても変更が関数1個で収まっていると思う。
https://www.membersedge.co.jp/blog/typescript-solid-dependency-inversion-principle/

## 単一責任の原則とファイルを分割することの違い
単一責任の原則は設計原則なので、結果的にクラスが増えてファイルが増えるかもしれないが、極端な話ファイルを分割しなくても実現できる。
一方ファイル分割はプログラムが見やすいようにクラスなどの単位でファイルを分けることなので、単一責任の原則とは関係なく実施される。

## Open-Closed-Principleの例
[こちら](https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design#open-closed-principle)を参考にした。

```Typescript
class Circle {
    public radius: number = 0;
    constructor(radius: number) {
        this.radius = radius;
    }
}

class Square {
    public length: number = 0;
    constructor(length: number) {
        this.length = length;
    }
}

class AreaCalculator {
    private shapeList: any[];
    constructor(shapeList: any[]) {
        this.shapeList = shapeList;
    }
    public sum(): number {
        let result: number = 0;
        this.shapeList.forEach((shape) => {
            if (shape instanceof Circle) {
                result += Math.pow(shape.radius, 2) * Math.PI;
            } else if (shape instanceof Square) {
                result += Math.pow(shape.length, 2);
            }
        });
        return result;
    }
}

const areaCalculator = new AreaCalculator([new Square(5), new Circle(3)]);
console.log(areaCalculator.sum());
```
上の例だと、例えば長方形も計算できるようにする場合、クラスの追加とAreaCalculatorの修正が必要になる。

これをOpen-Closed-principleに沿うように直すと次の通り各図形でクラスを作成し、AreaCalculatorのif文を無くす方法が考えられる。

これなら長方形を追加する場合はクラスの追加だけで済み、AreaCalculatorは手を加えなくていい。
```typescript
interface ShapeInterface {
    area(): number;
}

class Circle {
    public radius:number = 0;
    constructor(radius: number) {
        this.radius = radius;
    }

    public area(): number {
        return Math.pow(this.radius, 2) * Math.PI;
    }
}

class Square {
    public length: number = 0;
    constructor(length: number) {
        this.length = length;
    }

    public area(): number {
        return Math.pow(this.length, 2)
    }
}

class AreaCalculator {
    private shapeList: any[];
    constructor (shapeList: any[]) {
        this.shapeList = shapeList;
    }
    public sum(): number {
        return this.shapw
        return this.shapeList.reduce((acc, shape) => 
            acc += shape.area(), 0)
    }
}

const areaCalculator = new AreaCalculator([new Square(5), new Circle(3)]);
console.log(areaCalculator.sum());
```

## リスコフの置換原則に違反した場合の不都合は？
原則に違反したサブクラスの利用時にバグが発生する可能性がある。

原則に違反したサブクラスのテストがパスしない可能性がある。

## インターフェースを用いることの設計上のメリット
サブクラスに対して必要なメソッドの実装を強制できる。

## 依存性の逆転を用いる必要があるのはどんなとき？

## デメトルの法則とは（メリットも含めて説明）
「親クラス.子クラス.子クラスのメソッド」のように、直接のオブジェクトを経由してさらに別のオブジェクトにアクセスするのを避けるべきという法則。

この法則を守ることのメリット。
- 単体テストがしやすくなる
    - ユニットテストでは自分以外のオブジェクトはモックにして常に同じ値を返すようにしてテストするのが一般的なので、関係するオブジェクトが多いとそれだけモックがたくさん必要になる。
- コード変更の影響範囲を小さく保つことができる。
    - 関係するオブジェクトが多いと、それだけあるオブジェクトの変更の影響が及ぶ範囲も多くなる。デメトルの法則で結合度を低く保つことができる。

https://qiita.com/br_branch/items/37cf71dd5865cae21401

## 新人が書いたコードについて
問題点が分からなかったのでチームの方と話し合いたいです。

このクラスは他のオブジェクトをフィールドとして持っていないので、デメトルの法則に違反する恐れはないのではと思いました。

getter/setterを作った目的がデメトルの法則に違反しないようにとのことなら、デメトルの法則を守るにはgetter/setterを作るのではなく「クラス設計を見直してオブジェクトをいくつもまたいで参照するような設計を変更する」「他オブジェクトに状態を訪ねてその結果で処理するのではなく、オブジェクトそのものに処理をさせる（Don't tell ask）」のような変更が必要だと思う。

# 課題2
## コードの問題点
- 過去の購入履歴を全て取得してからアプリ側で絞り込んでいるので、購入履歴の数によっては性能の問題が発生する

## コードの修正案
ユーザーの平均購入履歴数を考慮して性能を満たせる場合は、今のままSQLで全取得してアプリで絞り込む。

性能を満たせない場合は、SQLで絞り込んで、アプリで結果だけ受け取り分岐させる。

各仕様変更があった場合の対応

「1年以内から2年以内」はアプリまたはSQLで絞り込む際の日付部分を変更して対応。

「プレミアム会員の場合は何個でも購入可能」はアプリでこの判定処理自体を通らないよう修正して対応。

「プレミアムは3カ月以内、それ以外は1年以内」はSQLで対応する場合はwhere句をバインドできる仕組みが必要。

# 課題3
## コードの問題点
- フィールドがpublicなので、意図せず誤った値に更新してしまう恐れがある

## 解決法
- クラスをカプセル化するため、フィールドをprivateにしてそれぞれ適切なgetter/setterを設定する。
    - PersonクラスのnameとstarWorkingAtは途中で変更する必要はないので、getterだけ作成し読み取りだけにする。名前を変更したい場合はそのための関数を作成する。
    - Companyクラスのpeopleは、リストの追加と削除を行うと想像できるので、それぞれの関数を用意する。getterとsetterは不要。

