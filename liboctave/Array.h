// Template array classes                              -*- C++ -*-
/*

Copyright (C) 1993 John W. Eaton

This file is part of Octave.

Octave is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2, or (at your option) any
later version.

Octave is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with Octave; see the file COPYING.  If not, write to the Free
Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

*/

#if !defined (_Array_h)
#define _Array_h 1

#if defined (__GNUG__) && defined (USE_EXTERNAL_TEMPLATES)
#pragma interface
#endif

// Classes we declare.

template <class T> class ArrayRep;
template <class T> class Array;
template <class T> class Array2;
template <class T> class Array3;
template <class T> class DiagArray;

/*
 * The real representation of all arrays.
 */

template <class T>
class ArrayRep
{
// Rethink resize()?
  friend class Array<T>;
  friend class Array2<T>;
  friend class Array3<T>;
  friend class DiagArray<T>;

protected:

  ArrayRep (T *d, int l);

public:

  ArrayRep (void);
  ArrayRep (int n);
  ArrayRep (const ArrayRep<T>& a);

  ~ArrayRep (void);

  int length (void) const;

  T& elem (int n);

  T elem (int n) const;

  void resize (int n);

private:

  T *data;
  int len;
  int count;
};

/*
 * One dimensional array class.  Handles the reference counting for
 * all the derived classes.
 */

template <class T>
class Array
{
protected:

  ArrayRep<T> *rep;

  Array (T *d, int l);

public:

  Array (void);
  Array (int n);
  Array (int n, const T& val);

  Array (const Array<T>& a);

  ~Array (void);

  Array<T>& operator = (const Array<T>& a);

  int capacity (void) const;
  int length (void) const;

  T& elem (int n);
  T& checkelem (int n);
  T& operator () (int n);

// No checking.
  T& xelem (int n);

  T elem (int n) const;
  T checkelem (int n) const;
  T operator () (int n) const;

  void resize (int n);
  void resize (int n, const T& val);

  const T *data (void) const;

  T *fortran_vec (void);
};

/*
 * Two dimensional array class.
 */

template <class T>
class Array2 : public Array<T>
{
protected:

  int d1;
  int d2;

  Array2 (T *d, int n, int m);

public:

  Array2 (void);
  Array2 (int n, int m);
  Array2 (int n, int m, const T& val);
  Array2 (const Array2<T>& a);
  Array2 (const DiagArray<T>& a);

  Array2<T>& operator = (const Array2<T>& a);

  int dim1 (void) const;
  int dim2 (void) const;

  int rows (void) const;
  int cols (void) const;
  int columns (void) const;

  T& elem (int i, int j);
  T& checkelem (int i, int j);
  T& operator () (int i, int j);

// No checking.
  T& xelem (int i, int j);

  T elem (int i, int j) const;
  T checkelem (int i, int j) const;
  T operator () (int i, int j) const;

  void resize (int n, int m);
  void resize (int n, int m, const T& val);
};

/*
 * Three dimensional array class.
 */

template <class T>
class Array3 : public Array2<T>
{
protected:

  int d3;

  Array3 (T *d, int n, int m, int k);

public:

  Array3 (void);
  Array3 (int n, int m, int k);
  Array3 (int n, int m, int k, const T& val);
  Array3 (const Array3<T>& a);

  Array3<T>& operator = (const Array3<T>& a);

  int dim3 (void) const;

  T& elem (int i, int j, int k);
  T& checkelem (int i, int j, int k);
  T& operator () (int i, int j, int k);

// No checking.
  T& xelem (int i, int j, int k);

  T elem (int i, int j, int k) const;
  T checkelem (int i, int j, int k) const;
  T operator () (int i, int j, int k) const;

  void resize (int n, int m, int k);
  void resize (int n, int m, int k, const T& val);
};

/*
 * A two-dimensional array with diagonal elements only.
 */

template <class T>
class DiagArray : public Array<T>
{
protected:

  int nr;
  int nc;

  DiagArray (T *d, int r, int c);

public:

  DiagArray (void);
  DiagArray (int n);
  DiagArray (int n, const T& val);
  DiagArray (int r, int c);
  DiagArray (int r, int c, const T& val);
  DiagArray (const Array<T>& a);
  DiagArray (const DiagArray<T>& a);

  DiagArray<T>& operator = (const DiagArray<T>& a);

  int dim1 (void) const;
  int dim2 (void) const;

  int rows (void) const;
  int cols (void) const;
  int columns (void) const;

  T& elem (int r, int c);
  T& checkelem (int r, int c);
  T& operator () (int r, int c);

// No checking.
  T& xelem (int r, int c);

  T elem (int r, int c) const;
  T checkelem (int r, int c) const;
  T operator () (int r, int c) const;

  void resize (int n, int m);
  void resize (int n, int m, const T& val);
};

#if defined (__GNUG__) && ! defined (USE_EXTERNAL_TEMPLATES)
#include "Array.cc"
#endif

#endif

/*
;;; Local Variables: ***
;;; mode: C++ ***
;;; page-delimiter: "^/\\*" ***
;;; End: ***
*/
