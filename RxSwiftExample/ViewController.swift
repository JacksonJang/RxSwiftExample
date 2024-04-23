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
        createPublishSubjectEx()
        createBehaviorSubjectEx()
        createReplaySubjectEx()
        createAsyncSubjectEx1()
        createAsyncSubjectEx2()
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

    private func createPublishSubjectEx() {
        let subject = PublishSubject<String>()

        subject.onNext("You can't see this message")
        
        subject.subscribe(onNext: { response in
            print("PublishSubject: \(response)")
        })
        .disposed(by: disposeBag)

        subject.onNext("PublishSubject response 1")
        subject.onNext("PublishSubject response 2")
    }
    
    private func createBehaviorSubjectEx() {
        let subject = BehaviorSubject(value: "BehaviorSubject Init")
        
        subject.onNext("You can see this message")
        
        subject.subscribe(onNext: { response in
            print("PublishSubject: \(response)")
        })
        .disposed(by: disposeBag)
        
        subject.onNext("response 1")
        subject.onNext("response 2")
    }
    
    private func createReplaySubjectEx() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)

        subject.onNext("Event 1")
        subject.onNext("Event 2")
        subject.onNext("Event 3")

        subject.subscribe(onNext: { response in
            print("ReplaySubject: \(response)")
        })
        .disposed(by: disposeBag)
    }
    
    private func createAsyncSubjectEx1() {
        let subject = AsyncSubject<String>()
        
        subject.onNext("Event 1")
        
        subject.subscribe(onNext: { response in
            print("ReplaySubject Ex1 : \(response)")
        }).disposed(by: disposeBag)
        
        subject.onNext("Event 2")
        subject.onNext("Event 3")
        
        subject.onCompleted()
    }
    
    private func createAsyncSubjectEx2() {
        let subject = AsyncSubject<String>()
        
        subject.onNext("Event 1")
        
        subject.subscribe(onNext: { response in
            print("ReplaySubject Ex2: \(response)")
        }).disposed(by: disposeBag)
        
        subject.onCompleted()
    }
}

