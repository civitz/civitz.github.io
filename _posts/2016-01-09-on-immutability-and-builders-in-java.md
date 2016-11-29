---
layout: post
title: On immutability and builders in java
---

Immutable object with builders in java are a nice solution but can be tricky when there are mandatory and optional attributes. I've elaborated a solution based on chained interfaces that can be implemented easily, and possibly automated.

Skip to the [implementation](#implementation-with-mandatory-attributes) part to see the code.

# Situation

On my day to day job I try my best to follow a functional style programming.

One of the key concepts of functional programming (and functional languages in particular) is immutability, which basically means that every object that you manage does not change it's attributes after creation.

Java was created around the concept that classes/objects encapsulate state and can change it, so the idea of "unchangeable" state is not the default behaviour.
In java, the `final` modifier ensures the _reference_ of the object does not change, but cannot ensure the referenced object's state does not change. In other words, objects (in java) are immutable if and only if all their attributes are recursively immutable.

# Solution

The only thing we can do in java is to force our new object to be immutable via extensive use of `final` attributes and objects which are known to be immutable in first place.

However, this forces the class to have all final attributes passed to the constructor (or created inside it, if it is not a merely data class), which is not a problem, but can be annoying and confusing in classes with many attributes.
The builder pattern comes to the rescue for this problem, providing methods to fill the needed attributes step-by-step before actually building objects.
The builder pattern, however, lets the user partially fill the attributes' list, thus leaving the created object in an invalid state. We can fix this by launching an exception in the method which actually calls the constructor: a solution that, while correct, does work only at runtime.

Let's see what can we do.

## Classic implementation

The following is an implementation of a classic immutable class with a builder.

```java
public class ClassicImmutable {
	private final String name; // String is an immutable class
	private final String address;
	private final int age; // primitives are immutable

	// This could be public
	private ClassicImmutable(String name, String address, int age) {
		this.name = name;
		this.address = address;
		this.age = age;
	}

  // getters, toString, builder
  public static Builder create(){
    return new Builder();
  }

  public static class Builder{
    // we can specify default values for attributes
    private String name;
    private String address;
    private int age;

    public Builder withName(String name){
      this.name = name;
      return this;
    }

    public Builder withAddress(String address){
      this.address = address;
      return this;
    }

    public Builder withAge(int age){
      this.age = age;
      return this;
    }

    public ClassicImmutable build(){
      return new ClassicImmutable(name, address, age);
    }
  }
}
```

While simple, this code let us build an immutable `ClassicImmutable` object with a simple:

```java
final ClassicImmutable cb;
cb = ClassicImmutable.create()
                     .withName("John");
                     .withAddress("Sesame street");
                     .withAge(5)
                     .build();
```

Which is an explicit way of defining the attributes of an object.

This solution doesn't address the mandatory attributes problem!
Surely we can add a check in the `Builder#build()` method like:

```java
public ClassicImmutable build(){
  if (/* parameters are not set*/) {
    throw new WhyWouldYouDoThisException();
  }
  return new ClassicImmutable(name, address, age);
}
```

Can we instead force the user to give at least the mandatory parts, while letting it skip the others? Can we do this with compile time checks?

## Implementation with mandatory attributes

In the following code, we see how we can force the mandatory parts in the builder:

```java
public class MandatoryAttributes {
  private final String name;
  private final String address;
  private final Optional<Integer> age;
  private final Optional<String> game;

  // same as before: getters, tostring, private constructor

  /**
  * Let you create an object via a builder
  *
  * @return a builder for {@link MandatoryAttributes} class.
  */
  public static MandatoryAttributes_name create() {
    return new Builder();
  }

  /* The first of the interfaces in the chain*/
  public interface MandatoryAttributes_name {
    MandatoryAttributes_address withName(String name);
  }

  public interface MandatoryAttributes_address {
    MandatoryAttributes_optional withAddress(String address);
  }

  /*The last of the interfaces in the chain: the optional part*/
  public interface MandatoryAttributes_optional {
    MandatoryAttributes_optional withAge(Integer age);

    MandatoryAttributes_optional withGame(String game);

    /** Get the real object*/
    MandatoryAttributes build();
  }

  private static class Builder
			implements MandatoryAttributes_address, MandatoryAttributes_name, MandatoryAttributes_optional {

		private String name;
		private String address;
		private Optional<Integer> age = Optional.empty();
		private Optional<String> game = Optional.empty();

		private Builder() {
		}

		@Override // from MandatoryAttributes_optional
		public MandatoryAttributes_optional withAge(Integer age) {
			this.age = Optional.ofNullable(age);
			return this;
		}

		@Override // from MandatoryAttributes_optional
		public MandatoryAttributes_optional withGame(String game) {
			this.game = Optional.ofNullable(game);
			return this;
		}

		@Override // from MandatoryAttributes_name
		public MandatoryAttributes_address withName(String name) {
			this.name = name;
			return this;
		}

		@Override // from MandatoryAttributes_address
		public MandatoryAttributes_optional withAddress(String address) {
			this.address = address;
			return this;
		}

		@Override // from MandatoryAttributes_optional
		public MandatoryAttributes build() {
			return new MandatoryAttributes(name, address, age, game);
		}
	}
```

Notice the three new interfaces: the first one is `MandatoryAttributes_name`, and the only method it has is the `withName()`, which returns a `MandatoryAttributes_address` type.
This interface, in turn, has only one method, returning a `MandatoryAttributes_optional` type object.
The last interface contains instead three methods, two returning `MandatoryAttributes_optional` (the same type), and one returning a `MandatoryAttributes` type.

What this chain of interfaces does is forcing the user to enter the mandatory attributes _and_ entering them in a particular order<sup id="a1">[1](#f1)</sup>.

The object can be constructed in a similar way:

```java
final MandatoryAttributes ma;
ma = MandatoryAttributes.create()
                        .withName("John");
                        .withAddress("Sesame Street")
                        .withAge(5);
                        .build();
```

But under the cover the interface chain does the following:

```java
MandatoryAttributes_name firstBuilder = MandatoryAttributes.create();
MandatoryAttributes_address secondBuilder = firstBuilder.withName("John");
MandatoryAttributes_optional thirdBuilder = secondBuilder.withAddress("Sesame Street");
MandatoryAttributes_optional fourthBuilder = thirdBuilder.withAge(5);
final	MandatoryAttributes ma = fourthBuilder.build();
```
Notice the `thirdBuilder`: it is the only one that doesn't return a different interface, thus allowing to call either `build()` directly, or enter other (optional!) attributes before building the actual object.

Moreover, the actual builder class does not look very different than the `ClassicImmutable.Builder` one. The mandatory one implements all the interfaces in the chain, and does return the correct `MandatoryAttributes_something` instead of `MandatoryAttributes.Builder`.

The only hassle is creating the interface chain, but that can be automated (e.g. an interface for every attribute that is not of type `Optional<Something>`).

# Get the code

You can find an unpolished version of this code at [this github repo](https://github.com/civitz/java-experiments/tree/master/src/main/java/io/github/civitz/java/experiments/immutables).

# [EDIT: 2016-11-30] 

Apparently immutables.io have already issued the problem with and provided [the same solution](https://immutables.github.io/immutable.html#staged-builder) with an handy annotation! Yay immutables!

# Footnotes

<b id="f1">1</b>The order is a side effect of the interface chain, but can be exploited to force a particular ordering. [↩](#a1).
