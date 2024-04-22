//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by 장효원 on 4/22/24.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createEx1()
        createColdObservableEx()
        createHotObservableEx()
    }

    private func createEx1() {
        let observable = Observable.of("Hello", "RxSwift")
        
        observable
            .subscribe(
                onNext:{ value in
                    print("Next: ", value)
                }, onError: { error in
                    print("Error: ", error)
                }, onCompleted: {
                    print("Completed")
                }, onDisposed: {
                    print("Disposed")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func createColdObservableEx() {
        let observable = Observable<Int>.create { observer in
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onCompleted()
            return Disposables.create()
        }

        observable.subscribe { event in
            print("Cold Observer 1: \(event)")
        }
        .disposed(by: disposeBag)

        observable.subscribe { event in
            print("Cold Observer 2: \(event)")
        }
        .disposed(by: disposeBag)
    }
    
    private func createHotObservableEx() {
        let observable = PublishSubject<Int>()

        observable.subscribe { event in
            print("Hot Observer 1: \(event)")
        }
        .disposed(by: disposeBag)

        observable.onNext(1)
        observable.onNext(2)

        observable.subscribe { event in
            print("Hot Observer 2: \(event)")
        }
        .disposed(by: disposeBag)

        observable.onNext(3)
        observable.onCompleted()
    }

}

